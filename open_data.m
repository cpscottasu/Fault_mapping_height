%enter the data type and the location of the data. 
data_type='tif_ll';%options 'las','tif_ll (geotif in lat/long)','tif_UTM (geotif in UTM)' 

%Indicate which portion of the fault was mapped
fault_mapping='base'; %options are 'top', 'steep', 'base'

% shape files 
%Box outlining the area of mapping
[test_polygon]=shaperead('hurricane_fault\bounding_box.shp'); 
%shape file for the mapping 
[faults]=shaperead('hurricane_fault\Fault_hurricane.shp'); 

% shape files 
%Box outlining the area of mapping
% [test_polygon]=shaperead('southern_test_zone\boundary.shp'); 
% %shape file for the mapping 
% [faults]=shaperead('southern_test_zone\southern_test_all.shp'); 

switch data_type
    case 'las'
        las_data=lasdata('../Bishop_test_area.las');
         x=las_data.x;y=las_data.y;z=las_data.z;


    case 'tif_ll'

        [x,y,z] = read_geotiff_latlong('hurricane_fault\Hurricane.tif');
      
    case 'tif_UTM'
        
        [x2,y2,z2] = read_geotiff('');
        
        
        x=[x1(:);x2(:);x3(:);x4(:)];
        y=[y1(:);y2(:);y3(:);y4(:)];
        z=[z1(:);z2(:);z3(:);z4(:)];
        
    otherwise disp('Please enter a valid data type')
end

%Do not change the code below 


switch data_type
     case 'tif_ll'

x1=[test_polygon.X];y1=[test_polygon.Y];

[x2,y2]=deg2utm(y1(1:end-1),x1(1:end-1));
[test_polygon.X] = x2;
[test_polygon.Y] = y2;

for i=1:length(faults)
x1 = [faults(i).X];y1=[faults(i).Y];
[x2,y2] = deg2utm(y1(1:end-1),x1(1:end-1));

y_1m = [min(y2):1:max(y2)];
x_1m = interp1(y2,x2,y_1m);

[faults(i).X] = [x_1m NaN];
[faults(i).Y] = [y_1m NaN];
end


end

 
return
figure
scatter(x(1:3:end),y(1:3:end),1,z(1:3:end),'filled') ;hold on 
% plot([test_polygon.X],[test_polygon.Y],'-k')
plot([faults.X],[faults.Y],'-b')
axis equal
legend('','Box','Faults')


