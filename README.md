Latin Hypercube Sampling Design using R
This repository contains an R script designed to perform Latin Hypercube Sampling (LHS) within a specified farm boundary. The script utilizes Digital Elevation Models (DEM) and KML files outlining farm boundaries to generate strategically placed sample points. These points are particularly useful for agricultural, environmental, and land-management studies.

Getting Started
Prerequisites
To run this script, ensure that R is installed on your system. The script requires the following R packages:

sf (for handling spatial data)
terra (for raster data manipulation)
lhs (for generating Latin Hypercube Samples)
ggplot2 (for plotting)
dplyr (for data manipulation)

Installation
Clone the repo or download the script to your local machine.

Usage
Set File Paths: Modify the script to include the paths to your specific DEM and farm boundary KML files.
Run the Script: Execute the script in your R environment to import the DEM and farm boundary, align Coordinate Reference Systems (CRS), perform Latin Hypercube Sampling, and visualize the results.

Customization: Adjust the n_samples variable to change the number of samples. You can also modify the random seed for different sampling outcomes.

Output
The script outputs a plot that includes:
  The DEM as a base layer.
  The farm boundary outlined in blue.
  Red dots representing the generated sample points within the farm boundary.

Note: This README provides a basic introduction and guide for the script. For a more comprehensive understanding, please refer to the comments within the script itself.
The code was written as part of an MSc project and is subject to change.
