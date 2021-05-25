function [x,y,dem] = read_geotiff(file )
 [dem,info]=geotiffread(file);

x=[info.XWorldLimits(1)+info.CellExtentInWorldX/2:info.CellExtentInWorldX:info.XWorldLimits(2)-info.CellExtentInWorldX/2];
y=[info.YWorldLimits(1)+info.CellExtentInWorldY/2:info.CellExtentInWorldY:info.YWorldLimits(2)-info.CellExtentInWorldY/2];
% 
[x,y]=meshgrid(x,y);
dem=flipud(dem);


end

