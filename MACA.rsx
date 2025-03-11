##climateR MACA=group
##Download MACA Data=name
##Variable=selection pr - Precipitation;tasmax - Maximum Temperature;tasmin - Minimum Temperature;rhsmax - Maximum Relative Humidity;rhsmin - Minimum Relative Humidity;huss - Specific Humidity;rsds - Solar Radiation;was - Wind Speed;uas - East Wind Component;vas - North Wind Component
##Model=selection CCSM4;CNRM-CM5;CSIRO-Mk3-6-0;GFDL-ESM2G;GFDL-ESM2M;HadGEM2-CC365;HadGEM2-ES365;IPSL-CM5A-LR;IPSL-CM5A-MR;IPSL-CM5B-LR;MIROC5;MIROC-ESM;MIROC-ESM-CHEM;NorESM1-M
##Scenario=selection rcp45;rcp85
##StartDate=string 1950-01-01
##EndDate=string 2099-12-31
##ROI=vector
##Output=output raster
library(climateR)
library(terra)
library(sf)
# Get climate data variables
vars <- c("pr", "tasmax", "tasmin", "rhsmax", "rhsmin", "huss", 
          "rsds", "was", "uas", "vas")[Variable + 1]
models <- c("CCSM4", "CNRM-CM5", "CSIRO-Mk3-6-0", "GFDL-ESM2G", "GFDL-ESM2M", 
           "HadGEM2-CC365", "HadGEM2-ES365", "IPSL-CM5A-LR", "IPSL-CM5A-MR", 
           "IPSL-CM5B-LR", "MIROC5", "MIROC-ESM", "MIROC-ESM-CHEM", "NorESM1-M")[Model + 1]
scenarios <- c("rcp45", "rcp85")[Scenario + 1]
# Process dates
start_date <- as.Date(StartDate)
end_date <- as.Date(EndDate)
# Prepare ROI
if (!inherits(ROI, "sf")) ROI <- st_as_sf(ROI)
if (st_crs(ROI) != 4326) ROI <- st_transform(ROI, 4326)
# Get and process climate data
climate_data <- getMACA(
    AOI = st_geometry(ROI),
    varname = vars,
    startDate = format(start_date, "%Y-%m-%d"),
    endDate = format(end_date, "%Y-%m-%d"),
    model = models,
    scenario = scenarios
)
# Convert to raster
r <- rast(climate_data)
# Mask to ROI and set names
r_masked <- mask(r, project(vect(ROI), crs(r)))
# Create monthly date sequence
date_seq <- seq(as.Date(paste0(format(start_date, "%Y-%m"), "-01")), 
               as.Date(paste0(format(end_date, "%Y-%m"), "-01")), 
               by = "month")
dates <- format(date_seq, "%Y%m")
names(r_masked) <- paste0(vars, "_", models, "_", scenarios, "_", dates[1:nlyr(r_masked)])
plot(r_masked)
# Set output
Output <- r_masked
#' ALG_DESC: This function downloads and visualizes MACA climate model projections based on your area of interest.
#' ALG_CREATOR: Hemed Lungo(Credit to Mike Johnson)
#' ALG_VERSION: 1.0.0