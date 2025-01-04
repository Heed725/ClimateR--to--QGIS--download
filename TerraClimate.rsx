##climateR TerraClimate=group
##Download TerraClimate Data=name
##Variable=selection aet - Actual Evapotranspiration;def - Water Deficit;pet - Potential Evapotranspiration;ppt - Precipitation;q - Runoff;soil - Soil Moisture;srad - Solar Radiation;swe - Snow Water Equivalent;tmax - Maximum Temperature;tmin - Minimum Temperature;vap - Vapor Pressure;ws - Wind Speed;vpd - Vapor Pressure Deficit
##StartDate=string 1958-01-01
##EndDate=string Current_Date
##ROI=vector
##Output=output raster

library(climateR)
library(terra)
library(sf)

# Get climate data variables
vars <- c("aet", "def", "pet", "ppt", "q", "soil", "srad", 
          "swe", "tmax", "tmin", "vap", "ws", "vpd")[Variable + 1]

# Process dates
start_date <- as.Date(StartDate)
end_date <- if(EndDate == "Current_Date") Sys.Date() else as.Date(EndDate)

# Prepare ROI
if (!inherits(ROI, "sf")) ROI <- st_as_sf(ROI)
if (st_crs(ROI) != 4326) ROI <- st_transform(ROI, 4326)

# Get and process climate data
climate_data <- getTerraClim(
    AOI = st_geometry(ROI),
    var = vars,
    startDate = format(start_date, "%Y-%m-%d"),
    endDate = format(end_date, "%Y-%m-%d")
)

# Convert to raster and calculate annual means
r <- rast(climate_data)
n_years <- nlyr(r) %/% 12
r_annual <- tapp(r, rep(1:n_years, each = 12), mean)

# Mask to ROI and set names
r_masked <- mask(r_annual, project(vect(ROI), crs(r_annual)))
names(r_masked) <- paste0(vars, "_annual_", 
                         format(seq(start_date, by = "year", length.out = n_years), "%Y"))

plot(r_masked)

# Set output
Output <- r_masked

#' ALG_DESC: This function Downloads and Visualize the climate variables basing on your area of interest.
#' ALG_CREATOR: Hemed Lungo (Credit to Mike Johnson)
#' ALG_VERSION: 1.0.0


