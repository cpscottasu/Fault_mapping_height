fileID = fopen('lidar_101919a.txt','w');
for i=1:length(heights_fault)
fprintf(fileID,'%8.2f %8.2f %8.2f \n',[heights_fault(i,6) heights_fault(i,7) heights_fault(i,8)]);
end
fclose(fileID);