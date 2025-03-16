##climateR LCMAP=group
##Download LCMAP Data=name
##Year=number 2019
##ROI=vector
##Output=output raster

library(climateR)
library(terra)
library(sf)

# Define the year for LCMAP data
year <- Year

# Prepare ROI
if (!inherits(ROI, "sf")) ROI <- st_as_sf(ROI)
if (st_crs(ROI) != 4326) ROI <- st_transform(ROI, 4326)

# Get LCMAP primary land cover data for the specified ROI and year
lcmap_data <- getLCMAP(AOI = ROI, year = year, type = "primary landcover")

# Reproject ROI to match LCMAP raster
ROI_projected <- project(vect(ROI), crs(lcmap_data))

# Mask the LCMAP raster to ROI
lcmap_masked <- mask(lcmap_data, ROI_projected)

# Plot the LCMAP data
plot(lcmap_masked)

# Set output
Output <- lcmap_masked

#' ALG_DESC: This function downloads and visualizes the LCMAP primary land cover data for the selected year (1985-2019).
#' ALG_CREATOR: Hemed Lungo (Credit Mike Johnson)
#' ALG_VERSION: 1.0.0
