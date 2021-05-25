close all
tic
 evaluate_parms=[];

%for  scarp_slope=scarp_slope_test 
height_sum=[];
for  scarp_slope=scarp_slope_test 
for scarp_dist=scarp_dist_test

  b=find(heights_fault(:,1)==scarp_slope& heights_fault(:,2)==scarp_dist);
  if ~isempty(b)
 
      faults_x_hand=[faults.X]*cosd(strike)-[faults.Y]*sind(strike);
faults_y_hand=[faults.X]*sind(strike)+[faults.Y]*cosd(strike);
      
figure
subplot(1,2,1)
plot(faults_x_hand/1e3,faults_y_hand/1e3,'.k');hold on 
scatter(heights_fault(b,6)/1e3,heights_fault(b,7)/1e3,5,heights_fault(b,8),'filled');
axis equal;colormap(jet);colorbar;
yl=ylim;caxis([-50 150])
title(['Slope = ',num2str(scarp_slope),', ','dist = ',num2str(scarp_dist)]);

subplot(1,2,2)
scatter(heights_fault(b,8),heights_fault(b,7)/1e3,1,'b','filled');hold on
xlabel('Scarp Height (m)');ylabel('North (km)');ylim(yl)
xlim([-50 150])

sum_ind=[];
for i=1:length(list)
    a=find(heights_fault(b,7)>list(i)-.5&heights_fault(b,7)<list(i)+.5);
   sum_ind=[sum_ind;[sum(heights_fault(b(a),8))]]; 
end
height_sum=[height_sum;[sum_ind]];

plot(medfilt1(sum_ind,5),list/1e3,'k-');hold on 
scatter(heights_fault(b,8),heights_fault(b,7)/1e3,7,'b','filled');hold on
xlabel('Scarp Height (m)');ylabel('North (km)');ylim(yl)
xlim([-50 150])



  end
% close all
% evaluate_mapping_code2
% evaluate_parms=[evaluate_parms;[scarp_slope scarp_dist length(faults_good) length(faults_bad) mapped_yes mapped_no]];

end
end
return
save([save_name,'_optimize_parms'],'evaluate_parms');



fp=evaluate_parms(:,3)./(evaluate_parms(:,3)+evaluate_parms(:,4));
close all
figure
subplot(1,3,1)
scatter(evaluate_parms(:,1),evaluate_parms(:,2),35,fp,'filled')
colorbar;colormap(jet);
xlabel('slope');ylabel('Length of fault (m)');title('Ratio of False positives to total point number')
caxis([0 1])
tp=evaluate_parms(:,5)./(evaluate_parms(:,5)+evaluate_parms(:,6));
subplot(1,3,2)
scatter(evaluate_parms(:,1),evaluate_parms(:,2),35,tp,'filled')
colorbar;colormap(jet);
xlabel('slope');ylabel('Length of fault (m)');title('Ratio of faults mapped to all faults')
caxis([0 1])

err=fp+tp;
a=find(err==max(err));
b=find(err>=max(err)*.95);

subplot(1,3,3)
scatter(evaluate_parms(:,1),evaluate_parms(:,2),35,err,'filled');hold on 
scatter(evaluate_parms(b,1),evaluate_parms(b,2),70,'b');hold on
scatter(evaluate_parms(a,1),evaluate_parms(a,2),70,'r','filled');hold on
colorbar;colormap(jet);
xlabel('slope');ylabel('Length of fault (m)');title('Evaluate fault parms')
% caxis([0 2])

b2=find(heights_fault(:,1)==evaluate_parms(a,1)& heights_fault(:,2)==evaluate_parms(a,2));

figure
subplot(1,2,1)
plot([faults.X]/1e3,[faults.Y]/1e3,'-k');hold on 
scatter(heights_fault(b2,6)/1e3,heights_fault(b2,7)/1e3,15,heights_fault(b2,8),'filled');
xlim([367.4738  369.5]);
axis equal;colormap(jet);colorbar;
%xlim([367.4738  369.5]);ylim([ 4.142    4.1455]*1e3)
yl=ylim;
title(['Slope = ',num2str(evaluate_parms(a,1)),', ','dist = ',num2str(evaluate_parms(a,2))]);
caxis([-10 35])
subplot(1,2,2)
scatter(heights_fault(b2,8),heights_fault(b2,7)/1e3,10,'b','filled');
xlim([-5,40]);xlabel('Scarp Height (m)');ylabel('North (km)');ylim(yl)
%ylim([ 4.142    4.1455]*1e3)

all_good_faults=[];c=find(b==a);b(c)=[];
for i=1:length(b)
  b1=find(heights_fault(:,1)==evaluate_parms(b(i),1)& heights_fault(:,2)==evaluate_parms(b(i),2));
  
  all_good_faults=[all_good_faults;[heights_fault(b1,:) ones(length(b1),1)*i]];
end


heights_fault1=heights_fault(b2,:);

error_fault=[];
for i=1:length(heights_fault1)
d=find(heights_fault1(i,7)==all_good_faults(:,7));
f=sqrt((heights_fault1(i,6)-all_good_faults(d,6)).^2);
f1=find(f<nearby_fault);

error_fault=[error_fault;[length(f1) std(all_good_faults(d(f1),8))]];

end


figure
scatter(heights_fault1(:,6)/1e3,heights_fault1(:,7)/1e3,5,error_fault(:,2),'filled');hold on 
colorbar;colormap(jet);caxis([0 8]);axis equal
title('Error on height calculation (m)')

load sfm_fault_outline
figure
scatter(heights_fault1(:,6)/1e3,heights_fault1(:,7)/1e3,5,error_fault(:,2),'filled');hold on 
plot(sfm_fault_x,sfm_fault_y,'k-')
colorbar;colormap(jet);caxis([0 3]);axis equal
title('Error on height calculation (m)')
figure
d=inpolygon(heights_fault1(:,6)/1e3,heights_fault1(:,7)/1e3,sfm_fault_x,sfm_fault_y);d=find(d==1);
scatter(heights_fault1(d,7)/1e3,heights_fault1(d,8),'.b');hold on 
errorbar(heights_fault1(d,7)/1e3,heights_fault1(d,8),error_fault(d,2),'b.')
xlabel('Distance NS (km)');ylabel('Scarp height')