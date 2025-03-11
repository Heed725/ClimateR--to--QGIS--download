##climateR BCSD=group
##Download BCSD Data=name
##Variable=selection pr - Precipitation;tas - Average Temperature;tasmax - Maximum Temperature;tasmin - Minimum Temperature
##Model=selection ACCESS1-0;ACCESS1-3;bcc-csm1-1;bcc-csm1-1-m;BNU-ESM;CanESM2;CCSM4;CESM1-BGC;CESM1-CAM5;CMCC-CM;CMCC-CMS;CNRM-CM5;CSIRO-Mk3-6-0;FGOALS-g2;FGOALS-s2;FIO-ESM;GFDL-CM2p1;GFDL-CM3;GFDL-ESM2G;GFDL-ESM2M;GISS-E2-H;GISS-E2-R;HadCM3;HadGEM2-AO;HadGEM2-CC;HadGEM2-ES;inmcm4;IPSL-CM5A-LR;IPSL-CM5A-MR;IPSL-CM5B-LR;MIROC4h;MIROC5;MIROC-ESM;MIROC-ESM-CHEM;MPI-ESM-LR;MPI-ESM-MR;MRI-CGCM3;NorESM1-M;PCM
##Scenario=selection rcp26;rcp45;rcp60;rcp85
##StartDate=string 1950-01-01
##EndDate=string 2099-12-31
##ROI=vector
##Output=output raster
library(climateR)
library(terra)
library(sf)
# Get climate data variables
vars <- c("pr", "tas", "tasmax", "tasmin")[Variable + 1]
models <- c("ACCESS1-0", "ACCESS1-3", "bcc-csm1-1", "bcc-csm1-1-m", "BNU-ESM", "CanESM2", 
           "CCSM4", "CESM1-BGC", "CESM1-CAM5", "CMCC-CM", "CMCC-CMS", "CNRM-CM5", 
           "CSIRO-Mk3-6-0", "FGOALS-g2", "FGOALS-s2", "FIO-ESM", "GFDL-CM2p1", "GFDL-CM3", 
           "GFDL-ESM2G", "GFDL-ESM2M", "GISS-E2-H", "GISS-E2-R", "HadCM3", "HadGEM2-AO", 
           "HadGEM2-CC", "HadGEM2-ES", "inmcm4", "IPSL-CM5A-LR", "IPSL-CM5A-MR", "IPSL-CM5B-LR", 
           "MIROC4h", "MIROC5", "MIROC-ESM", "MIROC-ESM-CHEM", "MPI-ESM-LR", "MPI-ESM-MR", 
           "MRI-CGCM3", "NorESM1-M", "PCM")[Model + 1]
scenarios <- c("rcp26", "rcp45", "rcp60", "rcp85")[Scenario + 1]
# Process dates
start_date <- as.Date(StartDate)
end_date <- as.Date(EndDate)
# Prepare ROI
if (!inherits(ROI, "sf")) ROI <- st_as_sf(ROI)
if (st_crs(ROI) != 4326) ROI <- st_transform(ROI, 4326)
# Get and process climate data
climate_data <- getBCSD(
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
#' ALG_DESC: This function downloads and visualizes BCSD climate model projections based on your area of interest.
#' ALG_CREATOR: Hemed Lungo(Credit to Mike Johnson)
#' ALG_VERSION: 1.0.0