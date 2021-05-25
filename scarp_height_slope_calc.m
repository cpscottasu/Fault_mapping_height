switch data_type
    
    case 'tif_ll'
        resolution=30;
    otherwise 
        resolution=1;
        
end


slope=zeros(size(zc'));
for i=min(xc):resolution:max(xc)
 a=find(xc>i-slope_dist/2&xc<i+slope_dist/2);
 b=find(xc>i-resolution/2&xc<=i+resolution/2);
 g=[ones(size(a)) xc(a)];
 m=inv(g'*g)*g'*double(zc(a));
 slope(b)=m(2);   
end


col=plasma(240);
% close all
figure
scatter(xc,zc,6,slope);
colormap(jet);colorbar
xlabel('East (km)');ylabel('height');title('Slope')
colormap(col)

caxis([0 1])
% 
% figure
% scatter(xc,slope,1,slope);
% colormap(jet);colorbar
% xlabel('East (km)');ylabel('height');title('Slope')