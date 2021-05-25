function [x1,y1,dem] = read_geotiff_latlong(file )
 [dem,info]=geotiffread(file);

x1=[info.LongitudeLimits(1)+info.CellExtentInLongitude/2:info.CellExtentInLongitude:info.LongitudeLimits(2)-info.CellExtentInLongitude/2];
y1=[info.LatitudeLimits(1)+info.CellExtentInLatitude/2:info.CellExtentInLatitude:info.LatitudeLimits(2)-info.CellExtentInLatitude/2];

[x1,y1]=meshgrid(x1,y1);
[x1,y1,zone]=deg2utm(y1(:),x1(:));

dem=flipud(dem);


end

