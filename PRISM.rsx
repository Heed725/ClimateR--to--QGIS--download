##climateR PRISM=group
##Download PRISM Data=name
##Variable=selection ppt - Precipitation;tmean - Mean Temperature;tmax - Maximum Temperature;tmin - Minimum Temperature;tdmean - Mean Dew Point Temperature;vpdmax - Maximum Vapor Pressure Deficit;vpdmin - Minimum Vapor Pressure Deficit
##Time=selection daily;monthly;annual
##StartDate=string 1981-01-01
##EndDate=string Current_Date
##ROI=vector
##Output=output raster
library(climateR)
library(terra)
library(sf)
# Get climate data variables
vars <- c("ppt", "tmean", "tmax", "tmin", "tdmean", "vpdmax", "vpdmin")[Variable + 1]
time_resolutions <- c("daily", "monthly", "annual")[Time + 1]
# Process dates
start_date <- as.Date(StartDate)
end_date <- if(EndDate == "Current_Date") Sys.Date() - 1 else as.Date(EndDate)
# Prepare ROI
if (!inherits(ROI, "sf")) ROI <- st_as_sf(ROI)
if (st_crs(ROI) != 4326) ROI <- st_transform(ROI, 4326)
# Get and process climate data
climate_data <- getPRISM(
    AOI = st_geometry(ROI),
    varname = vars,
    startDate = format(start_date, "%Y-%m-%d"),
    endDate = format(end_date, "%Y-%m-%d"),
    timeRes = time_resolutions
)
# Convert to raster
r <- rast(climate_data)
# Mask to ROI and set names
r_masked <- mask(r, project(vect(ROI), crs(r)))
# Create appropriate date sequence based on time resolution
if(time_resolutions == "daily") {
  date_seq <- seq(start_date, end_date, by = "day")
  date_format <- "%Y%m%d"
} else if(time_resolutions == "monthly") {
  date_seq <- seq(as.Date(paste0(format(start_date, "%Y-%m"), "-01")), 
                 as.Date(paste0(format(end_date, "%Y-%m"), "-01")), 
                 by = "month")
  date_format <- "%Y%m"
} else { # annual
  date_seq <- seq(as.Date(paste0(format(start_date, "%Y"), "-01-01")), 
                 as.Date(paste0(format(end_date, "%Y"), "-01-01")), 
                 by = "year")
  date_format <- "%Y"
}
dates <- format(date_seq, date_format)
names(r_masked) <- paste0(vars, "_", dates[1:nlyr(r_masked)])
plot(r_masked)
# Set output
Output <- r_masked
#' ALG_DESC: This function downloads and visualizes PRISM climate data based on your area of interest.
#' ALG_CREATOR: Hemed Lungo(Credit to Mike Johnson)
#' ALG_VERSION: 1.0.0