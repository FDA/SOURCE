# SOURCE
#### *Simulation of Opioid Use, Response, Consequences, and Effects*

Model, analysis code, data and output files for FDA opioid systems model, as utilized in two reports currently under review:
+ Lim, Stringfellow, et al. 2022, "Modeling the evolution of the U.S. opioid crisis for national policy development"
	+ Reports technical aspects of model development, estimation process, and replication of historical data from 1999-2020, as well as analyses of historical patterns and dynamics
+ Stringfellow, Lim, et al. 2022, "Reducing opioid use disorder and overdose in the United States: A dynamic modeling analysis"
	+ Reports analyses of 11 potential policy strategies for addressing the opioid crisis, with projected effects on overdose mortality and opioid use disorder from 2022-2032

**NOTE:** This is an archival version of the data and materials, corresponding to the version of Stringfellow et al. submitted on 18 Feb 2022. For the most updated version, please see the live repository at [github.com/FDA/SOURCE](https://github.com/FDA/SOURCE).

For any questions, please contact [Tse Yang Lim](mailto:tylim@mit.edu) or [Mohammad Jalali](mailto:msjalali@mgh.harvard.edu).

### Analysis & Graphing
Vensim model files and Python code (in .ipynb format) used for model estimation, analysis, and graphing of results in the published papers & supplementary materials. This is the 'working' directory of this repository.

### Data
Excel data and documentation files, as well as R code for pre-processing of NSDUH data. Explanations of data calculations, assumptions, literature reviews, etc. are in these files.

**Note:** Vensim data format (VDF) versions of the relevant portions of these data files used in the model are found in [Vensim Files](/Vensim%20Files/) and the [Model & Analysis Replication Package](/Model%20%26%20Analysis%20Replication%20Package/).

### Model Documentation & Review Reports
Documentation of model structure, estimation process, and supplementary analyses, as well as final reports from FDA-commissioned third-party reviews.

### Model & Analysis Replication Package
Minimal file and code package needed to replicate the analysis 'from scratch', without any pre-generated results or figures. **Use this to directly replicate the complete model estimation & analysis process.** To do so:
1. Make a local copy of this folder
2. Update the ControlFile OICC\*.txt according to the instructions [here](Analysis%20%26%20Graphing/README.md)
3. Run [OIC-OO v7.ipynb](Model%20%26%20Analysis%20Replication%20Package/OIC-OO%20v7.ipynb), loading the updated ControlFile when prompted; make sure any necessary Python packages are installed before attempting to run!
4. Then run [OSM Results Processing.ipynb](Model%20%26%20Analysis%20Replication%20Package/OSM%20Results%20Processing.ipynb)
5. Then run the desired Graphing .ipynb code in any order

**Important:** The model estimation code is intended to work with an experimental parallelised Vensim engine. With appropriate modifications to the main function calls (but not the analytical procedure), the same analysis can be run on regular commercially available [Vensim DSS](https://vensim.com/vensim-software/), though it will take *much* longer, particularly with all supplementary analyses (e.g. sensitivity, synthetic data). Please contact [Tom Fiddaman](mailto:tom@ventanasystems.com) for information on the experimental Vensim engine.

### Publication Figures & Results Summary
Main estimation results and output tables and figures used in the paper, including summary output files from various robustness and sensitivity analyses. **Publication figures and results can be downloaded directly here.**

### Vensim Files
The main Vensim model file (.mdl) and other supplementary Vensim files used for model estimation (e.g. optimization control, payoff definition, savelist files, and so on).
