% % % % %Code by Chelsea Scott, Arizona State University, July 2021 
close all;clear all
% 
% % % % % %load the DEM and fault maps; Must change the file here
open_data


%input the average fault strike here 
strike=0; %swaths are taken perpendicular to this value 

%parameters for mapping faults. SRTM options here:
swath_width=90; %width of strike-perendicular swaths; 5 for drone, lidar, pleiades, 90 for UTM
slope_dist=90; % window of topographic slope calculation. Ideal if multiple pixels 
scarp_slope_test=.02:.02:.4; % range of minimum slope to test 
scarp_dist_test=30:30:540;% range of minium scarp length to test 

% This works well with drone, lidar, pleiades
swath_width=5; %width of strike-perendicular swaths; 5 for drone, lidar, pleiades, 90 for UTM
slope_dist=2; % window of topographic slope calculation. Ideal if multiple pixels 
scarp_slope_test=0.01:.04:.75; % range of minimum slope to test 
scarp_dist_test=1:4:75;% range of minium scarp length to test 


%Base name to save files
save_name='hurricane';

plot_yes=0;
% folder_figure='';
%The folder to save the output plots must be created before running the
%code

%%%%%% Do not change code below 
%calculate scarp height 
calculate_scarp_height

%optimize fault parameters 
optimize_fault_parameters 
