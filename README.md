# SOURCE
#### *Simulation of Opioid Use, Response, Consequences, and Effects*
###### (Note: Automatic redirect from [github.com/tseyanglim/PROMISE](https://github.com/tseyanglim/PROMISE))

Model, analysis code, data and output files for FDA opioid systems model, as submitted for publication in *PNAS* as Lim et al. 2022, "Modeling the evolution of the U.S. opioid crisis for national policy development", and as utilized for analyses submitted for publication in *Science Advances* as Stringfellow et al. 2022, "Reducing opioid use disorder and overdose in the United States: A dynamic modeling analysis".

**NOTE:** This is an archival version of the data and materials, corresponding to the version of the manuscript submitted on (DATE). For the most updated version, please see the live repository at [github.com/FDA/SOURCE](https://github.com/FDA/SOURCE).

For any questions please contact [Tse Yang Lim](mailto:tylim@mit.edu)

### Analysis & Graphing
Vensim model files and Python code (in .ipynb format) used for model estimation, analysis, and graphing of results in the published papers & supplementary materials. This is the 'working' directory of this repository.

### Data
Excel data and documentation files, as well as R code for pre-processing of NSDUH data. Explanations of data calculations, assumptions, literature reviews, etc. are in these files.

**Note:** Vensim data format (VDF) versions of the relevant portions of these data files used in the model are found in [Vensim Files](/Vensim Files/) and the [Model & Analysis Replication Package](/Model & Analysis Replication Package/).

### Model Documentation & Review Reports
Documentation of model structure, estimation process, and supplementary analyses, as well as final reports from FDA-commissioned third-party reviews.

### Model & Analysis Replication Package
Minimal file and code package needed to replicate the analysis 'from scratch', without any pre-generated results or figures. **Use this to directly replicate the complete model estimation & analysis process.** To do so:
1. Make a local copy of this folder
2. Update the ControlFile OICC\*.txt according to the instructions [here](Analysis & Graphing/Readme.MD)
3. Run OIC-OO v6.ipynb, loading the updated ControlFile when prompted; make sure any necessary Python packages are installed before attempting to run!
4. Then run OSM Results Processing.ipynb
5. Then run the desired Graphing .ipynb code in any order

**Important:** The model estimation code is intended to work with an experimental parallelised Vensim engine. With appropriate modifications to the main function calls (but not the analytical procedure), the same analysis can be run on regular commercially available Vensim DSS, though it will take *much* longer, particularly with all supplementary analyses (e.g. sensitivity, synthetic data). Please contact [Tom Fiddaman](mailto:tom@ventanasystems.com) for information on the experimental Vensim engine.

### Publication Figures & Results Summary
Main estimation results and output tables and figures used in the paper, including summary output files from various robustness and sensitivity analyses. **Publication figures and results can be downloaded directly here.**

### Vensim Files
The main Vensim model file (.mdl) and other supplementary Vensim files used for model estimation (e.g. optimization control, payoff definition, savelist files, and so on).
