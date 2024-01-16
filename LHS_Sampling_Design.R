# Load Necessary Libraries
library(sf)
library(terra)
library(lhs)
library(ggplot2)
library(dplyr)

# Define file paths
# Users should replace the paths below with the paths to their own files
dem_file_path <- "path/to/your/DEM_file.tif"  # Replace with the path to your DEM file
farm_boundary_file_path <- "path/to/your/farm_boundary_file.kml"  # Replace with the path to your farm boundary KML file

# Import the DEM (Digital elevation model) and farm boundry
dem <- rast(dem_file_path)
farm_boundary <- st_read(farm_boundary_file_path)


# Check and Align CRS
# This is to ensure that the map projections are the same. (Important when more than one raster layer are included - cLHS)
crs_dem <- terra::crs(dem)
crs_farm_boundary <- st_crs(farm_boundary)

# Transform farm_boundary CRS to match DEM, if different
# In the case that the projections are not the same, the code will rewrite the projections.
if (crs_dem != crs_farm_boundary) {
farm_boundary <- st_transform(farm_boundary, crs = crs_dem)
}

# Set the random seed for reproducibility
# Change seed value for different sample generation output
set.seed(101)

# Generate Latin Hypercube Samples
# LHS generates samples in square shape, thus samples might fall outside irregular farm boundries.
# Set sample size, and change size to desired sample generation output results.
n_samples <- 100  # Set the desired number of samples
samples_normalized <- randomLHS(n_samples, 2)  # 2 for two dimensions (x and y)

# Transform samples to fit within the bounding box of the farm
# To ensure that only generated samples that falls within the farm boundries are shown on output map.
bb <- st_bbox(farm_boundary)
samples_scaled <- cbind(bb["xmin"] + samples_normalized[,1] * (bb["xmax"] - bb["xmin"]),
                        bb["ymin"] + samples_normalized[,2] * (bb["ymax"] - bb["ymin"]))

# Convert to SpatialPointsDataFrame and assign DEM CRS
#samples_sp <- SpatialPointsDataFrame(samples_scaled, data.frame(id = 1:n_samples),
#                                    proj4string = crs(dem))
df =  data.frame(samples_scaled)
df$id = 1:n_samples
colnames(df) = c("x","y", "id")

df = sf::st_as_sf(df, coords = c("x","y"), crs = crs_dem)

# Filter Points to Ensure They Are Within the Farm Boundary
samples_inside_farm <- st_intersection(df, farm_boundary)

# Convert DEM to a data frame for ggplot
dem_df <- terra::as.data.frame(dem, xy=T)
colnames(dem_df) <- c("x", "y", "value") # Rename columns for clarity

# Plot the Results
ggplot() +
  geom_tile(data = dem_df, aes(x = x, y = y, fill = value)) + # Use 'value' for fill
  scale_fill_viridis_c() +
  geom_sf(data = farm_boundary, fill = NA, color = "blue") +
  geom_sf(data = samples_inside_farm, color = "red") +
  coord_sf() +
  theme_minimal()
