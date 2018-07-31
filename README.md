# All experimental data from the Sine Wave project

This repository contains raw, unprocessed, and processed experimental data from the Sine Wave project by [Beattie et al](https://physoc.onlinelibrary.wiley.com/doi/abs/10.1113/JP275733). Importantly, this repository includes all raw data, including for additional pacing protocols not included in the [sine-wave repository](https://github.com/mirams/sine-wave). These protocols are diveroli\_eq_prop, equal\_proportions, made\_up\_2\_shifted, made\_up\_3\_shifted, max\_diff, maz\_wang\_div\_diff, original\_sine and wang\_eq\_prop. This repository contains all files for each cell, and the code used to process the raw data through dofetilide subtraction and leak subtraction.

## Main Folder

[LeakSubtractor.m](LeakSubtractor.m): Given an experiment reference (e.g. `'16713110'`), this file will leak subtract and dofetilide subtract experimental data read from the `.dat` files in [FullExperimentalData](FullExperimentalData/) for that cell and place each into a folder named after the cell in [DofetilideSubtracted](DofetilideSubtracted/). Note that two of the cells ( `'16704007'` and `'16704047'`) have less data available, and also use different protocols for activation\_kinetics\_1 and activation\_kinetics\_2. The original leak resistances used by Kylie for data processing are hard-coded and used to ensure that all data is as consistent as possible. The commented code can be used to attempt this in an automated manner and produces similar results.

[Readme.txt.docx](Readme.txt.docx): Readme file provided by Dr Kylie Beattie.

## Dofetilide Subtracted

[DofetilideSubtracted](DofetilideSubtracted/): Contains one sub-folder for each cell. Each cell's folder contains dofetilide subtracted and leak subtracted data. Note that not all protocols are available for all cells. These files can be copied into other repositories and used for fitting.

## Experimental Data

[ExperimentalData](ExperimentalData/): Contains the experimental data used by [Beattie et al](https://physoc.onlinelibrary.wiley.com/doi/abs/10.1113/JP275733) and available in the [sine-wave repository](https://github.com/mirams/sine-wave). Also includes the averaged experimental data.

[cell_index.txt](ExperimentalData/cell_index.txt): Identifies the cell numbers in the data with the cell numbers in [Beattie et al](https://physoc.onlinelibrary.wiley.com/doi/abs/10.1113/JP275733).

## Full Experimental Data

[abf](FullExperimentalData/abf/): This folder contains the raw data trces output by the patch clamping apparatus for each cell.

[dat](FullExperimentalData/dat/): Raw data in text format. Can be loaded into Matlab by `importdata`. Files are formatted as follows: Column 1: time, Column 2: recorded current, Column 3: voltage as recorded (somewhat blockier than the original protocol, which is probably a better representation of the voltage experienced by the cell). In the case of 'traditional' step protocols like the activation protocols, additional columns are present. All even columns (2,4,6,...) are experimentally recorded currents and the subsequent columns (3,5,7,...) are the voltages recorded while generating them. Time only appears once as all steps have the same duration.

## Protocols

[Protocols](Protocols/): Contains a .mat file for each pacing protocol.




