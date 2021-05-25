# Fault_mapping_height
Map fault scarps and calculate scarp height 

Fault Mapping Algorithm developed for: A novel tool to map normal fault geometry and scarp height from topographic data: Application to Volcanic Tablelands and the Hurricane Fault, Western US

To be submitted to Lithosphere in July 2021

Algorithm developed by Chelsea Scott (1) in collaboration with Isabelle Manighetti (2), Ramon Arrowsmith (1), Frédérique Leclerc (2), Cassandra Brigham (3), Tiziano Giampietro (2), Lionel Mattéo (2), and Daniel Lao Davila (4) 

1 Arizona State University, 2 Université Côte d'Azur (France), 3 University of Washington, 4 Oklahoma State University

Here, we present our algorithm which maps topographic fault scarps and calculates scarp height. 

Software: 
The algorithm runs on Matlab. 

Lasdata: This is available from the Matlab file exchange and is used to read the las files.  https://www.mathworks.com/matlabcentral/fileexchange/48073-lasdata

Deg2utm: This is available from the Matlab file exchange and is used to convert the latitude and longitude in geortif files to UTM.  https://www.mathworks.com/matlabcentral/fileexchange/10915-deg2utm

Algorithm Input: 

Manually-drawn fault maps in the calibration zone: This calibration map is used to calibrate the fault mapping parameters (θ_length  and θ_slope). The calibration map should be done at the desired scale of the fault mapping (e.g., fine or coarse). The mapping can be done at the top, steepest location (approximate middle), or bottom of the scarp, and this location must be specified in the algorithm. The fault map is expected to be save as a shape file.  

Box bounding the area of the calibration map: This should be a polygon shape file that bounds the area to be used for the calibration. 

Topography datasets: The algorithm accepts las files (typically used for point clouds) and geotiffs with horizontal coordinates in meters or latitude/ longitude.  

Everything should be saved in the same coordinate reference system (CRS). Las files are assumed to be saved in meters. Geotiffs can be in meters (i.e., UTM grids) or lat/long (e.g., SRTM) but this information must be specified in open_data (see below). Elevations are assumed to be in meters. 

Algorithm options: 

The master script is “Scarp_height_code_master”. There are several options and variables that must be set prior to running the code. 

In opendata: 
Data_type: 'las' (point cloud in las format), 'tif_ll (geotif in lat/long)', 'tif_UTM (geotif in UTM)' 

fault_mapping: options include 'top', 'steep', 'base' to indicate which part of the fault was mapped 

Shape files: test_polygon (outline of the area where the calibration mapping was done) and faults (calibration fault map). This can also include other lineations such as streams if the user would like these to be included in the calibration) 

In “Scarp_height_code_master”, 

swath_width is the width of strike-perpendicular swaths. We recommend 5 m for sUAS, lidar, Pleiades and  90 m for SRTM

slope_dist is the moving window size used to calculate the topographic slope. Ideally, this dimension is at least several pixels. We recommend 2 m for sUAS, lidar, Pleiades and  90 m for SRTM

Calibration parameters: Ideally many parameters should be tested as a too small sample size may miss the correct parameters. 

Here is a possible set of recommendations, although these are likely to vary based on the faulting and climate. To decrease run-time, we suggest testing parameters with a large step size over a large range and then to focus in better-fitting areas. The algorithm can find local minima if a sufficient set of parameters are not searched. 

sUAS, lidar, Pleiades: scarp_slope_test=0.01:.04:.75; scarp_dist_test=1:4:75;% (this tests an extensive set of parameters, which is a good place to but may not be needed for all projects.) 

SRTM: scarp_slope_test=0.02:0.02:4; scarp_dist_test=30:30:540

The algorithm generates several files with the results. save_name indicates the base name for the saved files. 
save_name='lidar_southern';

Plot_yes (1 for yes, 0 for no) will plot the intermediate results. These are good to look at but be aware that many figures are generated. 


Output: The following information is save in “save_name”_best.mat 

x_alg: x position in the rotated coordinate system of the faults
y_alg: y position in the rotated coordinate system of the faults
x_alg_UTM; x position of the faults in UTM 
x_alg_UTM; y position of the faults in UTM 
height_alg: fault height in meters
error_fault: counts, std error, lower bound error, upper bound error, all in meters
scarp_slope_best: best scarp parameter for mapping 
scarp_dist_best: best distance parameter for mapping
list: y points of measurements
average strike of faults as indicated by the user. 

The following information is save in “save_name”.mat 

A single matrix with the output of “save_name” and the list of tested scarp length and slope parameters. 

Demo examples: 
We provide two examples for running the fault mapping algorithm. 

Southern test zone, Bishop with airborne lidar topography: The fault maps and bounding box are in the folder southern_test_zone. The mapping was done at the top of the scarp. The topography dataset can be generated by running this job at OpenTopography. 

https://portal.opentopography.org/lidarDataset?opentopoID=OTLAS.042016.26911.1&minX=-118.48879812336241&minY=37.42271607442166&maxX=-118.4846703469309&maxY=37.42629217632438

Hurricane fault, Arizona with SRTM topography: 
The fault map and bounding box are in hurricane_fault. The mapping was done at the base of the scarp. The topography dataset can be generated by running this job at OpenTopography https://portal.opentopography.org/raster?opentopoID=OTSRTM.082015.4326.1&minX=-113.4549222986141&minY=35.7624929247002&maxX=-113.075506121718&maxY=36.88965004473896
