##climateR Daymet=group
##Download Daymet Data=name
##Variable=selection dayl - Day Length;prcp - Precipitation;srad - Solar Radiation;swe - Snow Water Equivalent;tmax - Maximum Temperature;tmin - Minimum Temperature;vp - Vapor Pressure
##StartDate=string 1980-01-01
##EndDate=string 2019-12-31
##ROI=vector
##Output=output raster
library(climateR)
library(terra)
library(sf)
# Get climate data variables
vars <- c("dayl", "prcp", "srad", "swe", "tmax", "tmin", "vp")[Variable + 1]
# Process dates
start_date <- as.Date(StartDate)
end_date <- as.Date(EndDate)
# Prepare ROI
if (!inherits(ROI, "sf")) ROI <- st_as_sf(ROI)
if (st_crs(ROI) != 4326) ROI <- st_transform(ROI, 4326)
# Get and process climate data
climate_data <- getDaymet(
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
#' ALG_DESC: This function downloads and visualizes Daymet daily surface weather data based on your area of interest.
#' ALG_CREATOR: Hemed Lungo(Credit to Mike Johnson)
#' ALG_VERSION: 1.0.0
