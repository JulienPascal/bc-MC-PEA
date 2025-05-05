#!/bin/bash

# Start MATLAB without GUI
matlab -nosplash -nodesktop << EOF

% Add Dynare path
addpath('/usr/lib/dynare/matlab');

% Change to the desired directory
cd '~/Documents/REPOSITORIES/bc-MC-PEA_Private/3.stochastic_growth'

% Run Dynare with the specified .mod file
dynare neogrowth.mod

%get variable positions
k_pos=strmatch('k',M_.endo_names,'exact');
c_pos=strmatch('c',M_.endo_names,'exact');
z_pos=strmatch('z',M_.endo_names,'exact');

var_positions=[k_pos; c_pos; z_pos];

% transpose to get column for each variabe
Sim_series = oo_.endo_simul(var_positions,:)';

%get variable names
var_names=M_.endo_names_long(var_positions,:);

% Create folder
if ~exist('output/Linearization', 'dir')
   mkdir('output/Linearization')
end



% Save the results to a CSV file
%% SS value
% Create the table with the desired data
T = table(oo_.var_list, oo_.mean);

% Simulated series
Sim_table = array2table(Sim_series, 'VariableNames', var_names);
writetable(Sim_table, 'output/Linearization/Sim_series.csv');

% Set the desired column names
T.Properties.VariableNames = {'Variable', 'MeanValue'};

% Write the table to a CSV file
writetable(T, 'output/Linearization/SS_values.csv');

%% Policy coefficients
%oo_.dr.ghx and oo_.dr.ghu
%% State Space
% state space representation:
% S_t = A * S_{t-1} + B * e_{t},
% X_t = C * S_{t-1} + D * e_{t};
%initiate the matrices
% baseline model
A = [];
B = [];
C = [];
D = [];

%state variables
state = M_.state_var';
%control variables
control = [1:1:size(oo_.dr.ghu,1)]';
for j = 1:size(state,1)
  control( control == state(j) ) = [];
end

A = [oo_.dr.ghx( oo_.dr.inv_order_var( state ), : ) ];
B = [oo_.dr.ghu( oo_.dr.inv_order_var( state ), : ) ];
C = [oo_.dr.ghx( oo_.dr.inv_order_var( control ), : ) ];
D = [oo_.dr.ghu( oo_.dr.inv_order_var( control ), : ) ];

S_variables_names = M_.endo_names(state);
X_variables_names = M_.endo_names(control);
shocks_names = M_.exo_names;

%% IRFs
%% Simulations - Sequence of random shocks
len_T = 10;
e1 = zeros(len_T,1); %TFP shock;
e1(1) = 1.0;

horizon = size(e1,1)+1;
shocks = zeros(M_.exo_nbr, horizon);
shocks( strcmp(shocks_names, 'eps'),2:horizon) = e1;

Ssim = zeros( size(state,1), horizon);
Xsim = zeros( size(control,1), horizon);
Ssim(:,1) = []; %
Xsim(:,1) = []; %
for j = 2:horizon
  % State
  % S_t = A * S_{t-1} + B * e_{t},
  Ssim(:,j) = A * Ssim(:,j-1) + B * shocks(:,j);
  % Space
  % X_t = C * S_{t-1} + D * e_{t};
  Xsim(:,j) = C * Ssim(:,j-1) + D * shocks(:,j);
end

% Save name state
T = table(S_variables_names);
T.Properties.VariableNames = {'State_variables'};
writetable(T, 'output/Linearization/state_variables_names.csv');

% Save name controls
T = table(X_variables_names);
T.Properties.VariableNames = {'Control_variables'};
writetable(T, 'output/Linearization/control_variables_names.csv');

% Save name exo
T = table(shocks_names);
T.Properties.VariableNames = {'Exo_variables'};
writetable(T, 'output/Linearization/exo_variables_names.csv');

csvwrite('output/Linearization/A.csv', A)
csvwrite('output/Linearization/B.csv', B)
csvwrite('output/Linearization/C.csv', C)
csvwrite('output/Linearization/D.csv', D)

% Exit MATLAB
exit
EOF
