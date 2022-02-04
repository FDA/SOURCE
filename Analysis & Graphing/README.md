# Opioids-model Iterative Calibration
**WARNING: THIS VERSION REQUIRES VENGINE TO RUN!**

1. Save the `.ipynb` file in the same folder as your model and relevant modelling files (`.voc`, `.vpd`, `.vsc`, `.vdf` inputs, etc.). The program will copy all relevant files to a new subfolder and work there, as it will usually generate a lot of new files.

2. You need a single 'Control File' as input. This is a JSON-format .txt file read in as a Python dictionary to control the calibration. Ensure that all fields are appropriately updated before running the `.ipynb` file. Note that all strings will need to be "double-quoted". The order of fields does not matter. The list of fields and subfields in the Control File is below.
	
3. Once the Control File is updated, ensure it is in the same folder as the `.ipynb` file.

4. Run the `.ipynb` notebook. It will prompt you for the name of the Control File, after which everything should run automatically. 
	- **IMPORTANT:** Vengine has a warning popup on initialization, which the script should dismiss automatically (using the `keyboard` module, as noted in the script). There are two known times this may fail - on first running the script, and if your computer suspends or sleeps (even if running on server). For the first issue, on first running the script, if Vengine does not start running the optimization automatically after a few seconds, just manually dismiss the popup. For the second issue, change computer power settings to never sleep/suspend while running this script.

5. All output from the `.ipynb` script itself will be written to a .log file under `{baserunname}.log`, separate from the Vensim-generated output files.

6. When updating the Control File, watch out for commas and other punctuation! If you get a `JSON decoder error` when you input the Control File name, double-check the punctuation in the Control File.

### Control File Fields
1. baserunname - the base name you want to use for the Vensim runs; also determines the name of the subfolder that will be created
2. simsettings - a Python-format dictionary containing some or all of the following keys:
	1. model - the base `.mdl` file
	2. data - a Python-format list of `.vdf/.vdfx` data files to load
	3. payoff, sensitivity, optparm, savelist, senssavelist - the relevant Vensim control files (`.vpd`, `.vsc`, `.voc`, `.lst`, and `.lst` respectively)
	4. changes - a Python-format list of changes files to load (e.g. `.cin`, `.out`)
3. vensimpath - filepath to your Vensim `.exe` - **MAKE SURE TO UPDATE THIS** - (for Vengine version of script, this should go to the Vengine `.exe` instead)
4. vensim7path - filepath to your basic Vensim `.exe` (in Vengine version of script, used for simple, non-computationally-intensive operations)
5. graphs - `.vgd` file for displaying graphs in Vensim
6. fractolfactor - factor by which to increase `FRACTIONAL_TOLERANCE` for initial round of calibrations (for greater speed)
7. threshold - absolute value of the payoff improvement from one iteration of main-model calibration to the next (in the iterative calibration process) at which to automatically stop the calibration
8. iterlimit - maximum number of iterations (through the step-wise iterative calibration process) to loop through before breaking the calibration, to use as circuit breaker - if set to 0, will bypass the iterative process, either running a full-model all-params calibration directly, or bypassing that if an .out file from such a calibration (with name `{baserunname}_main_full.out`) already exists
9. twostep - switch for two-step calibration with re-estimation of weights; set to 0 to inactivate or 1 to activate - **WARNING:** the two-step process with re-estimation is unstable and yields unrliable results; do not use!
10. timelimit - maximum amount of time to wait between checking for output updates of a single model - if Vensim stalls out, this is how long the script will wait before killing Vensim and starting again - see below re: choosing an appropriate timelimit
11. mccores - to turn off MCMC, set this to 0; if 1 or more, will run MCMC after completing iterative calibration
12. mcsettings - a Python-format dictionary of Vensim optimization control settings to use for running MCMC. These will be used to modify the `.voc` file for the MCMC runs. Be sure to set either `OPTIMIZER` or `SENSITIVITY` to turn on MCMC (or just leave as-is); the `MCLIMIT` setting gives the total number of iterations per MCMC process. Additional MCMC and optimization control settings can be added as desired.
13. samplefrac - the fraction of the MCMC samples to use for sensitivity analysis; if `MCLIMIT` is large, make sure this is quite small or your sensitivity analysis output will be massive! (sensitivity sample = `samplefrac x (MCLIMIT - MCBURNIN`))
14. noise - switch to turn on noise resampling; set to 1 to generate resampled noise, or 0 to turn off
15. noise_dto - order for detrending residuals for noise resampling; set to 0 to turn off
16. odlinekey - keys for identifying overdose-related estimated parameters, used to split `.voc` file for overdose-specific partial model calibration
17. basescens - a Python-format list of baseline scenario `.cin` files to use for projections; these will be run combinatorially with the policy scenarios in `policylist`
18. scenariolist - a Python-format list of additional scenario `.cin` files to run in addition to `basescens`; these will *not* be run combinatorially with the policy scenarios in `policylist`
19. policylist - a Python-format list of policy scenario `.cin` files to test in combination with the baseline scenarios in `basescens`
20. testlit - a Python-format list of alternative condition `.cin` files, for estimating the model under alternative assumption sets
21. analysissettings - a Python-format dictionary with additional entries used for analysis and graphing of results; note that most of these will only make sense in the context of the analysis code in the Results Processing `.ipynb`
	1. sensrange - fraction by which to perturb assumed parameter values (for parameters in `sensvars` for paramatetric sensitivity analysis; this should be a small value (0.05-0.1 works well)
	2. sensvars - a Python-format list of assumed (not estimated) parameters to test for sensitivity of model estimates & projections
	3. fitlist - a Python-format list of list-format duples, showing all fit-to-data variables used in model estimation, with *paired* `Elm` subscript elements and text-string display names, used for identifying calibration target variables and graphing
	4. priorlist - a Python-format list of list-format triples, showing all point prior values used in model estimation, with `Elm` subscript elements, year in which prior value is compared, and text-string display names
	5. param_percs - a Python-format list of float values for percentile values of estimated parameters to report, for use in generating credible intervals on parameters
	6. mainfits - a Python-format list of `Elm` subscripts for main historical fit-to-data graph
	7. projfits - a Python-format list of `Elm` subscripts for main projections graph
	8. figdpi - DPI resolution at which to save figures
	9. figext - file extension for saving figures (e.g. "svg", "jpg")
	10. bounds - a Python-format list of list-format duples, each a pair of percentiles defining a credible interval to display on the projections graph
	11. yearvals - a Python-format list of variable names for which to read values from model output, for years corresponding to `years` and bounds corresponding to `yv_percs`
	12. years - a Python-format list of years for which to read output values for variables in `yearvals`
	13. yv_percs - a Python-format list with a pair of percentiles defining the credible interval to report for `yearvals` - note this only takes a single pair, unlike some other comparable bounds / percentile specifications
	14. outvars - a Python-format list of output variable names for comparing in sensitivity analysis panel
	15. projvars - a Python-format list of additional projected output variable names for comparing in sensitivity analysis panel
	16. styear - the start year of the model run
	17. endyear - the end year of the model run
	18. projyear - the end year for model projections
	19. compperc - percentile at which to compare outputs under different projection assumptions, for sensitivity analysis of projection assumptions
	20. polvars - a Python-format list of output variable names for annual versions of cumulative output variables in `outvars`, for use in policy analysis
	21. annvars - a Python-format list of output variable names for annual versions of additional projected cumulative output variables in `projvars`, for use in policy analysis
	22. polstart - the start year for policy implementation
	23. polquants - a Python-format list of float-format percentile values to report for projected outcome variables in policy analysis
	24. polsavelist - savelist `.lst` file to use specifically for full-sensitivity policy analyses; because these involve tracking every trace in the sensitivity sample, files get very large, so *only* the key outcome variables (usually `polvars` and `annvars`) should be tracked
	25. polnames - a Python-format dictionary of `.cin` file names (without extension) from `policylist` and corresponding text-string display names for use in graphing
	26. holdoutyear - cutoff year for holdout dataset, for out-of-sample validation test
	27. hold_percs - a Python-format list of list-format duples, each a pair of percentiles defining a predicted credible interval to compare against holdout datapoints
	28. hold_excl - a Python-format list of `Elm` subscripts to exclude from holdout data analysis comparison
	29. hold_drop - a Python-format list of `Elm` subscripts to exclude from secondary reported holdout dataset prediction accuracy
	30. synsample - the number of synthetic datasets to generate for synthetic data analysis
	31. syn_percs - a Python-format list of float values for percentile values of synthetic data estimated parameters to report, for use in calculating synthetic data credible interval accuracy
	32. syn_reppercs - a Python-format list of credible interval percentages for which to report synthetic data accuracies
	33. syn_mainperc - primary credible interval percentage for which to report synthetic data interval accuracy
	34. paramvals - a Python-format list of variable names for which to report values from model, for ease of results processing & reporting
22. proj_subs - a Python-format list of all `Proj` subscript elements
23. lkdict - a Python-format dictionary of feedback loop sets and corresponding Python-format lists of feedback effect strength variable names, for use in loop knockout analysis

**IMPORTANT re: timelimit parameter:**
The timelimit parameter is only supposed to kill and restart Vensim if it is stalled out. As long as optimization is continuing (i.e. the optimization `.log` is still being written to), even if it the overall process takes longer than the timelimit, it will be allowed to complete - UNLESS a single optimization run does not yield any log file changes for longer than the timelimit. If optimization control settings are high-intensity enough that this happens, you WILL get stuck in an infinite loop - so if doing high-res optimization, adjust this parameter up accordingly. On the other hand, if set too high, more time will be wasted when Vensim does happen to stall out. Note that the timelimit is increased by 5 x for full-model and sensitivity runs due to these outputting log file changes less frequently.