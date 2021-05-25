heights_fault=zeros(10^7,10);p2=1;

% select points within the boundary polygon 
a3=find(inpolygon(x(:),y(:),[test_polygon.X],[test_polygon.Y])==1);
 x=x(a3);y=y(a3);z=z(a3);
%  a3=1:length(x(:));
x=x(:);y=y(:);z=z(:);
gb=find(z==-9999);
x(gb)=[];y(gb)=[];z(gb)=[];
whos x y z

% % 
% xrot=x*cosd(strike)-y*sind(strike);
% yrot=x*sind(strike)+y*cosd(strike);
% x=xrot;y=yrot;
% % % 
list=[min(y(:))+50:swath_width:max(y(:))-50];
% % % % 
% % % % 
warning off


for pl= 1:length(list)
     [pl/length(list)]
   
 t=list(pl);
   %Step 1 
xbox1=[min(x) max(x) max(x) min(x)];ybox1=[t t t+swath_width t+swath_width];
c=inpolygon(x,y,xbox1,ybox1);c=find(c==1);
close all

zc=z(c);zc=zc-median(zc);
xc=x(c)-min(x(c));

%Step 2 
scarp_height_slope_calc

for  scarp_slope=scarp_slope_test 
for scarp_dist=scarp_dist_test
close all

%this sets the transects where the scarp height will be calculated.

% Step 3 
% figure
% scatter(xc,zc,1,slope);
% colormap(jet);colorbar
% xlabel('East (km)');ylabel('height');title('Slope')
% 
% figure
% scatter(xc,slope,1,slope);
% colormap(jet);colorbar
% xlabel('East (km)');ylabel('height');title('Slope')

id_scarps

% figure
% scatter((xc(1:10:end)+min(x(c)))/1e3,zc(1:10:end)+min(z(c)),3,scarps(1:10:end),'filled');hold on
% colormap(jet);
% ylabel('Elevation (m)');xlabel('East (km)');title('ID scarps')

id_flats

if plot_yes==1
figure
scatter((xc), zc,3,salami,'filled');hold on
colormap(jet)
ylabel('Elevation (m)');xlabel('East (km)')
 title('ID flats')
axis equal
end 

scarp_line_fitting

if plot_yes==1;
saveas(gcf,[folder_figure,'/transect_',num2str(round(list(pl))),'scarp_slope_',num2str(100*scarp_slope),'scarp_dist_',num2str(scarp_dist)],'png') 
saveas(gcf,[folder_figure,'/transect_',num2str(round(list(pl))),'scarp_slope_',num2str(100*scarp_slope),'scarp_dist_',num2str(scarp_dist)],'fig')  
end
end

close all
 
end
 if mod(pl,100)==0
save([save_name,'_strike',num2str(strike),'.mat'],'heights_fault','scarp_slope_test','scarp_dist_test');
 end
end


%end
 f=sum(heights_fault,2);
 f1=find(f==0);
 heights_fault(f1,:)=[];
 
 
save([save_name,'_strike',num2str(strike),'.mat'],'heights_fault','scarp_slope_test','scarp_dist_test');
heights_fault_rot=heights_fault;

xh=heights_fault(:,5);
base=heights_fault(:,6);
top=heights_fault(:,7);
yh=heights_fault(:,8);


heights_fault(:,5)=xh*cosd(strike)+yh*sind(strike);
heights_fault(:,6)=base*cosd(strike)+yh*sind(strike);
heights_fault(:,7)=top*cosd(strike)+yh*sind(strike);
heights_fault(:,8)=-xh*sind(strike)+yh*cosd(strike);

save([save_name],'heights_fault','scarp_slope_test','scarp_dist_test');

a=find(abs(heights_fault(:,9))>10);

rb=redblue(260);
figure
scatter(xh(a),yh(a),4,heights_fault(a,9),'filled')
colorbar
colormap(rb)
caxis([-400 400])

