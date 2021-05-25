 b=find(heights_fault(:,1)==scarp_slope& heights_fault(:,2)==scarp_dist);

 y_alg=heights_fault(b,8); height_alg=heights_fault(b,9);
  switch fault_mapping
    
    case 'top'
       x_alg=heights_fault(b,7);
    case 'steep' 
         x_alg=heights_fault(b,5);
    case 'base' 
         x_alg=heights_fault(b,6);
end

if ~isempty(b)
 
faults_x_hand=[faults.X]*cosd(strike)-[faults.Y]*sind(strike);
faults_y_hand=[faults.X]*sind(strike)+[faults.Y]*cosd(strike);
      
figure
% subplot(1,2,1)
plot(x_alg/1e3,y_alg/1e3,'.k');hold on 
scatter(x_alg/1e3,y_alg/1e3,5,height_alg,'filled');
axis equal;colormap(jet);colorbar;
yl=ylim;caxis([-10 40])
title(['Slope = ',num2str(scarp_slope),', ','dist = ',num2str(scarp_dist)]);

evaluate_mapping_code2
evaluate_parms=[evaluate_parms;[scarp_slope scarp_dist length(faults_good) length(faults_bad) mapped_yes mapped_no]];
else
evaluate_parms=[evaluate_parms;[scarp_slope scarp_dist NaN NaN NaN NaN]];
end
% close all

