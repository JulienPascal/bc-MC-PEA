# bc-MC-PEA

This repository contains the code for the paper bc-MC-PEA paper.


## Folders and Files
### Folder `0.MSIE_formula`
Illustration of the mean squared integration error (MSIE) formula (Equation 12) in a simplified linear framework.

### Folder `1.stochastic_growth`
Solve the stochastic growth model using standard PEA, as well as bc-MC-PEA. The notebook `stochastic_growth_Colab_1.ipynb` was executed on Google Colab (CPU, High RAM mode). This created the zip file stochastic_growth_Colab_1.zip.

---

### Computational details
#### Folder `0.MSIE_formula`
Computations were performed on a local machine, using Python Python 3.8.10 on an 12-core Intel(R) Core(TM) i7-8850H processor, running at 2.60 GHz. See the results of "cpuinfo" at the end of the notebook for more details.

#### Folder `1.stochastic_growth`
Computations were performed in Google Colab (CPU, High RAM mode) using Python 3.11.12 on an 8-core AMD EPYC 7B12 processor running at 2.25 GHz. See the results of "cpuinfo" at the end of the notebook for more details.

Remark: The 1st order linearized solution, used as a starting point for the parameter vector, relies on the Octave version of Dynare, which can be installed on Google Colab. Dynare is called directly in jupyter notebook, using the script `solve_neogrowth_octave.m`.
