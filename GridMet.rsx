##climateR GridMET=group
##Download GridMET Data=name
##Variable=selection bi - Burning Index;erc - Energy Release Component;etr - Reference ET;fm100 - 100-hour dead fuel moisture;fm1000 - 1000-hour dead fuel moisture;pdsi - Palmer Drought Severity Index;pet - Potential Evapotranspiration;pr - Precipitation;rmax - Maximum Relative Humidity;rmin - Minimum Relative Humidity;sph - Specific Humidity;srad - Downward Surface Shortwave Radiation;th - Wind Direction;tmmn - Minimum Temperature;tmmx - Maximum Temperature;vs - Wind Speed
##StartDate=string 1979-01-01
##EndDate=string Current_Date
##ROI=vector
##Output=output raster
library(climateR)
library(terra)
library(sf)
# Get climate data variables
vars <- c("bi", "erc", "etr", "fm100", "fm1000", "pdsi", "pet", "pr", 
          "rmax", "rmin", "sph", "srad", "th", "tmmn", "tmmx", "vs")[Variable + 1]
# Process dates
start_date <- as.Date(StartDate)
end_date <- if(EndDate == "Current_Date") Sys.Date() - 1 else as.Date(EndDate)
# Prepare ROI
if (!inherits(ROI, "sf")) ROI <- st_as_sf(ROI)
if (st_crs(ROI) != 4326) ROI <- st_transform(ROI, 4326)
# Get and process climate data
climate_data <- getGridMET(
    AOI = st_geometry(ROI),
    varname = vars,
    startDate = format(start_date, "%Y-%m-%d"),
    endDate = format(end_date, "%Y-%m-%d")
)
# Convert to raster
r <- rast(climate_data)
# Mask to ROI and set names
r_masked <- mask(r, project(vect(ROI), crs(r)))
dates <- format(seq(start_date, end_date, by = "day"), "%Y%m%d")
names(r_masked) <- paste0(vars, "_", dates[1:nlyr(r_masked)])
plot(r_masked)
# Set output
Output <- r_masked
#' ALG_DESC: This function downloads and visualizes GridMET meteorological data based on your area of interest.
#' ALG_CREATOR: Hemed Lungo(Credit to Mike Johnson)
#' ALG_VERSION: 1.0.0