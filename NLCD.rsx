##climateR NLCD=group
##Download NLCD Data=name
##Year=number 2019
##ROI=vector
##Output=output raster

library(climateR)
library(terra)
library(sf)

# Define the year for NLCD data
year <- Year

# Prepare ROI
if (!inherits(ROI, "sf")) ROI <- st_as_sf(ROI)
if (st_crs(ROI) != 4326) ROI <- st_transform(ROI, 4326)

# Get NLCD land cover data for the specified ROI and year
nlcd_data <- getNLCD(AOI = ROI, year = year, type = "land cover")

# Mask to ROI
nlcd_masked <- mask(nlcd_data, project(vect(ROI), crs(nlcd_data)))

# Plot the NLCD data
plot(nlcd_masked)

# Set output
Output <- nlcd_masked

#' ALG_DESC: This function downloads and visualizes the NLCD land cover data based on your area of interest for 2001, 2011,2016,2019.
#' ALG_CREATOR: Hemed Lungo(Credit Mike Johnson)
#' ALG_VERSION: 1.0.0
