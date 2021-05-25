 


% b=find(heights_fault(:,1)==scarp_slope_test(5)& heights_fault(:,2)==scarp_dist_test(7));
% b=1:length(heights_fault);
 strike=0;
      faults_x_hand=[faults.X]*cosd(strike)-[faults.Y]*sind(strike);
faults_y_hand=[faults.X]*sind(strike)+[faults.Y]*cosd(strike);
      
figure
subplot(1,2,1)
plot(faults_x_hand/1e3,faults_y_hand/1e3,'.k');hold on 
scatter(heights_fault(b,6)/1e3,heights_fault(b,7)/1e3,5,heights_fault(b,8),'filled');
axis equal;colormap(jet);colorbar;
yl=ylim;caxis([-50 150])
title(['Slope = ',num2str(scarp_slope),', ','dist = ',num2str(scarp_dist)]);


manual_measurements_folder='D:\Bishop2019\bisop_scarp\scarp_height_calcs\Scarp_height_code_sept2019\Bishop_total_50m';

man_measurements=[];
for i=1:58
    load([manual_measurements_folder,'\transect_',num2str(i),'.mat'])
    if ~isempty(transect_results)
    a=transect_results.end;
    
    man_measurements=[man_measurements;[a(2) transect_results.throw]];
    end
end

subplot(1,2,2)
scatter(heights_fault(b,8),heights_fault(b,7)/1e3,1,'b','filled');hold on
xlabel('Scarp Height (m)');ylabel('North (km)');ylim(yl)
xlim([-50 150])

sum_ind=[];
for i=1:length(list)
    a=find(heights_fault(b,7)>list(i)-.5&heights_fault(b,7)<list(i)+.5);
   sum_ind=[sum_ind;[sum(heights_fault(b(a),8))]]; 
end
% height_sum=[height_sum;[sum_ind]];

plot(medfilt1(sum_ind,5),list/1e3,'k-');hold on 
plot( man_measurements(:,2), man_measurements(:,1)/1e3,'.r','MarkerSize',15)
scatter(heights_fault(b,8),heights_fault(b,7)/1e3,7,'b','filled');hold on
xlabel('Scarp Height (m)');ylabel('North (km)');ylim(yl)
xlim([-50 150])




legend('Individual algor','sum algorithm','manual measurements')
