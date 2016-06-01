# TypeChef Analysis of uClibc

Contains various scripts to run static analysis and sampling strategies with TypeChef on uClibc.

The setup requires multiple steps. Contact me if there are any issues.

## Setup & Source code

The requiered source code as well as all preparation steps have been already performed, you can start directly with the analysis. In case your operating system does not offer the requiered C system headers, you can find the used headers for our evaluation [here](https://github.com/aJanker/TypeChef-GNUCHeader).


## How to run the analysis

Go `study/farce-uclibc` and run `runVAA.sh` to run the variability-aware analysis and for sampling `runSampling.sh`. 
