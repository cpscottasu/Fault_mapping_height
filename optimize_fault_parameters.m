close all
load(save_name)
faults_UTM=heights_fault;
load([save_name,'_strike',num2str(strike),'.mat'])
tic
 evaluate_parms=[];

 scarp_slope_test=unique(heights_fault(:,1));
 scarp_dist_test=unique(heights_fault(:,2));
 
%for  scarp_slope=scarp_slope_test 
height_sum=[];
for  scarp_slope=scarp_slope_test'
for scarp_dist=scarp_dist_test'
plot_cal=0;
evaluating_plot 
end
end

close all
fp=evaluate_parms(:,3)./(evaluate_parms(:,3)+evaluate_parms(:,4));
vid=viridis(240);
close all
figure
subplot(1,3,1)
scatter(evaluate_parms(:,1),evaluate_parms(:,2),35,fp,'filled')
colorbar;colormap(jet);
xlabel('slope');ylabel('Length of fault (m)');title('Ratio of False positives to total point number')
caxis([0 1]);
ylim([0 75]);xlim([0 .75])
ylim([0 23]);xlim([0 .23])
ylim([0 max(scarp_dist_test)]);xlim([0 max(scarp_slope_test)])
tp=evaluate_parms(:,5)./(evaluate_parms(:,5)+evaluate_parms(:,6));

subplot(1,3,2)
scatter(evaluate_parms(:,1),evaluate_parms(:,2),35,tp,'filled')
colorbar;colormap(jet);
xlabel('slope');ylabel('Length of fault (m)');title('Ratio of faults mapped to all faults')
caxis([0 1]);caxis([0 1]);ylim([0 75]);xlim([0 .75])
ylim([0 23]);xlim([0 .23])
ylim([0 max(scarp_dist_test)]);xlim([0 max(scarp_slope_test)])
err=fp+tp;
a_best=find(err==max(err));a_best=a_best(1);
b=find(err>=max(err)*.95);

subplot(1,3,3)
scatter(evaluate_parms(:,1),evaluate_parms(:,2),35,err,'filled');hold on 
scatter(evaluate_parms(b,1),evaluate_parms(b,2),70,'b');hold on
scatter(evaluate_parms(a_best,1),evaluate_parms(a_best,2),70,'r','filled');hold on
colorbar;colormap(jet);
xlabel('slope');ylabel('Length of fault (m)');title('Evaluate fault parms')
% caxis([0 2])
colormap(vid);caxis([0 2]);ylim([0 75]);xlim([0 .75])
ylim([0 23]);xlim([0 .23])
ylim([0 max(scarp_dist_test)]);xlim([0 max(scarp_slope_test)])

%plot the fault evaluation for the best parameters
scarp_slope_best=evaluate_parms(a_best,1);
scarp_dist_best=evaluate_parms(a_best,2);

scarp_slope=scarp_slope_best;scarp_dist=scarp_dist_best;
plot_cal=1;
evaluating_plot 

a_2=find(heights_fault(:,1)==evaluate_parms(a_best,1)& heights_fault(:,2)==evaluate_parms(a_best,2));
b=find(err>=max(err)*.95);
b2=[];
for h=1:length(b)
b2=[b2;find(heights_fault(:,1)==evaluate_parms(b(h),1)& heights_fault(:,2)==evaluate_parms(b(h),2))];
end

y_alg_all=heights_fault(:,8); height_alg_all=heights_fault(:,9);
y_alg=heights_fault(a_2,8); height_alg=heights_fault(a_2,9);
y_alg_almost=heights_fault(b2,8); height_alg_almost=heights_fault(b2,9);

y_alg_UTM=faults_UTM(a_2,8);
slope_almost=heights_fault(b2,1);
length_almost=heights_fault(b2,2);


switch fault_mapping
    case 'top'
       x_alg_all=heights_fault(:,7);
       x_alg=heights_fault(a_2,7);x_alg_UTM=faults_UTM(a_2,7);
       x_alg_almost=heights_fault(b2,7);
    case 'steep' 
       x_alg_all=heights_fault(:,5);
       x_alg=heights_fault(a_2,5);x_alg_UTM=faults_UTM(a_2,5);
       x_alg_almost=heights_fault(b2,5);
    case 'base' 
       x_alg_all=heights_fault(:,6);
       x_alg=heights_fault(a_2,6);x_alg_UTM=faults_UTM(a_2,6);
       x_alg_almost=heights_fault(b2,6);
end


rb=redblue(240);
figure
subplot(1,2,1)
plot([faults.X]/1e3,[faults.Y]/1e3,'.k');hold on 
scatter(x_alg_UTM/1e3,y_alg_UTM/1e3,15,height_alg,'filled');
% xlim([367.4738  369.5]);
axis equal;colormap(jet);colorbar;
%xlim([367.4738  369.5]);ylim([ 4.142    4.1455]*1e3)
yl=ylim;
% title(['Slope = ',num2str(evaluate_parms(a,1)),', ','dist = ',num2str(evaluate_parms(a,2))]);
caxis([-300,300])
colormap(rb)
subplot(1,2,2)
scatter(height_alg,y_alg_UTM/1e3,10,'b','filled');
xlim([-50,500]);xlabel('Scarp Height (m)');ylabel('North (km)');ylim(yl)
%ylim([ 4.142    4.1455]*1e3)



error_fault=[];
for i=1:length(x_alg)

sets=[];
for j=1:length(b)
   c=find(evaluate_parms(b(j),1)==slope_almost&evaluate_parms(b(j),2)==length_almost);
   d=sqrt((x_alg_almost(c)-x_alg(i)).^2+(y_alg_almost(c)-y_alg(i)).^2); 
   e=find(d==min(d));
   sets=[sets;height_alg_all(c(e))];
end

if ~isempty(sets)
    
s=sort(sets);
med=s(round(.5*length(s)));
low_bound=med-s(ceil(.16*length(s)));
top_bound=s(round(.84*length(s)))-med;

error_fault=[error_fault;[length(sets) std(sets) low_bound  top_bound   ]];
else
    error_fault=[error_fault;[length(sets) NaN NaN NaN   ]];
end

end


figure
scatter(x_alg/1e3,y_alg/1e3,5,error_fault(:,1),'filled');hold on 
colorbar;colormap(jet);caxis([0 20]);axis equal
title('Error on height calculation (m)')




save([save_name,'_best'], 'x_alg','y_alg','x_alg_UTM','y_alg_UTM','height_alg','error_fault','scarp_slope_best','scarp_dist_best','strike','list')
return 
%x_alg: x position in rotated coordinate system used to measure the faults
%y_alg: y position in rotated coordinate system used to measure the faults
%x_alg_UTM; x position in UTM 
%x_alg_UTM; y position in UTM 
%height_alg: height_alg
%error_fault: counts, std error, lower bound error, upper bound error 
%scarp_slope_best: best scarp parameter for mapping 
%scarp_dist_best: best distance parameter for mapping
%list: y points of measurements
% average strike of faults as indicated by the user. 

