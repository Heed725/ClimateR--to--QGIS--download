# ClimateR Installation Guide for QGIS

## Prerequisites

### Required Software
- R version 4.x or higher
- R Studio
- QGIS 3.x
- R Processing Plugin for QGIS

### Required R Libraries
- climateR
- terra
- sf (>= 1.0.0)

## Installation Steps

### 1. Install R and RStudio
- Download and install the latest version of R (4.x or higher) from the [R Project website](https://www.r-project.org/)
- Download and install RStudio from the [RStudio website](https://www.rstudio.com/products/rstudio/download/)

### 2. Install Required R Libraries
Open RStudio and run the following commands in the console:
```R
install.packages("climateR")
install.packages("terra")
install.packages("sf")
```

### 3. Set Up R Processing Plugin
1. Open QGIS
2. Go to "Plugins" → "Manage and Install Plugins"
3. Search for "R Provider"
4. Install the "Processing R Provider" plugin
5. Enable the plugin by checking the box next to it

### 4. Configure R in QGIS
1. Go to "Settings" → "Options" → "Processing" → "Providers"
2. Find "R" in the providers list
3. Set the R folder path to your R installation directory
4. Set the R library folder path where your R packages are installed

### 5. Test Installation
1. Open the Processing Toolbox in QGIS
2. Look for the R scripts section
3. Run a simple R script to verify the connection between QGIS and R is working

## Troubleshooting

If you encounter issues:
1. Verify that all paths are correctly set in the QGIS Processing options
2. Ensure R libraries are installed in the correct location
3. Check that R version is compatible with installed packages
4. Verify that the R Processing Plugin is properly enabled in QGIS

## Additional Resources
- ClimateR Documentation
- QGIS R Processing Plugin Documentation
- R Spatial Documentation

## Youtube Links Tutorial 
https://www.youtube.com/watch?v=4aCFh4a6nQc&t=24s (part 1/2)

https://www.youtube.com/watch?v=fylZegmxDx0&t=47s (part 2/2)
## Version Information
This guide was created for:
- QGIS 3.x
- R 4.x
- ClimateR (latest version)
- R Processing Plugin (latest version)
