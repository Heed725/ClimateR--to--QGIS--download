##climateR CHIRPS Data=group
##Download CHIRPS Data=name
##StartDate=string 1981-01-01
##EndDate=string Current_Date
##ROI=vector
##Output=output raster

library(climateR)
library(terra)
library(sf)

# Process dates
start_date <- as.Date(StartDate)
end_date <- if(EndDate == "Current_Date") Sys.Date() else as.Date(EndDate)

# Prepare ROI
if (!inherits(ROI, "sf")) ROI <- st_as_sf(ROI)
if (st_crs(ROI) != 4326) ROI <- st_transform(ROI, 4326)

# Get CHIRPS precipitation data
chirps_data <- getCHIRPS(
    AOI = st_geometry(ROI),
    startDate = format(start_date, "%Y-%m-%d"),
    endDate = format(end_date, "%Y-%m-%d")
)

# Convert to raster and calculate annual sums
r <- rast(chirps_data)
n_years <- nlyr(r) %/% 12
r_annual <- tapp(r, rep(1:n_years, each = 12), sum)  # Using sum instead of mean for precipitation

# Mask to ROI and set names
r_masked <- mask(r_annual, project(vect(ROI), crs(r_annual)))
names(r_masked) <- paste0("precip_annual_", 
                         format(seq(start_date, by = "year", length.out = n_years), "%Y"))

plot(r_masked)

# Set output
Output <- r_masked

#' ALG_DESC: This function Downloads and Visualizes annual CHIRPS precipitation data for your area of interest.
#' ALG_CREATOR: (Based on Hemed Lungo's TerraClim script)
#' ALG_VERSION: 1.0.0