switch data_type
    
    case 'tif_ll'
        err_size=225;
    otherwise 
        err_size=30/3;
        
end

  
fault_length=length([faults.X]);

faults_x_hand=[faults.X]*cosd(strike)-[faults.Y]*sind(strike);
faults_y_hand=[faults.X]*sind(strike)+[faults.Y]*cosd(strike);

test_x_r=[test_polygon.X]*cosd(strike)-[test_polygon.Y]*sind(strike);
test_y_r=[test_polygon.X]*sind(strike)+[test_polygon.Y]*cosd(strike);



a3=inpolygon(faults_x_hand(1:fault_length),faults_y_hand(1:fault_length),test_x_r,test_y_r);a3=find(a3==1|isnan(faults_x_hand(1:fault_length)));
faults_x_hand=faults_x_hand(a3);faults_y_hand=faults_y_hand(a3);

faults_good=[];faults_bad=[];

mapped_hand=zeros([length(faults_x_hand),1]);
for h=  1:length(x_alg)
   
    
    dist1=sqrt((x_alg(h)-faults_x_hand).^2+(y_alg(h)-faults_y_hand).^2);
    
    if min(dist1)<err_size
    
   faults_good=[faults_good;[x_alg(h) y_alg(h)]];
    else
    faults_bad=[faults_bad;[x_alg(h) y_alg(h)]];
    end

    
%    for p=1:length(tumuli2)-1
%       xp=tumuli2(p).X;yp=tumuli2(p).Y;
%       a1=inpolygon(faults_long,  faults_lat,xp,yp);a1=find(a1==1);
%  fault_good_bad(a1)=1; 
%      
%    end
%     a=find(fault_good_bad==1);faults_good=[faults_good;[x_alg(i) y_alg(i)]];
%      a=find(fault_good_bad==0);faults_bad=[faults_bad;[faults_long(a) faults_lat(a)]];
end

mapped_hand=zeros([length(faults_x_hand),1]);
for h=1:length(faults_x_hand)
 dis=sqrt((faults_x_hand(h)-x_alg).^2+(faults_y_hand(h)-y_alg).^2);
    if min(dis)<err_size
        mapped_hand(h)=-1;
end
end

mapped_yes=length(find(mapped_hand==-1));
mapped_no=length(find(mapped_hand==0));

if plot_cal==1
figure
 subplot(1,2,1)
%plot(x_alg/1e3,y_alg/1e3,'.r');hold on 
plot(faults_x_hand/1e3,faults_y_hand/1e3,'k.');hold on 
plot(faults_good(:,1)/1e3,faults_good(:,2)/1e3,'.b');hold on
plot(faults_bad(:,1)/1e3,faults_bad(:,2)/1e3,'.r');hold on
legend('Faults','Hand Mapped','Not Mapped by hand (False positive)')
axis equal
title(['Slope = ',num2str(scarp_slope),', ','dist = ',num2str(scarp_dist)]);

subplot(1,2,2)
title(['Slope = ',num2str(scarp_slope),', ','dist = ',num2str(scarp_dist)]);
plot(faults_x_hand/1e3,faults_y_hand/1e3,'.k');hold on
scatter(faults_x_hand/1e3,faults_y_hand/1e3,13,mapped_hand,'filled')
colormap(jet);colorbar;caxis([-1.2 .2])
title(['False positive score = ',num2str(round(length(faults_good)/(length(faults_good)+length(faults_bad)),2)),', ',...
   'missed fault score = ',num2str(round(mapped_yes/(mapped_yes+mapped_no),2))] );
axis equal

end

% figure
% plot(faults_x_hand,faults_y_hand,'-k');hold on 
% for p=1:length(tumuli2)-1
%       xp=tumuli2(p).X;yp=tumuli2(p).Y;hold on 
%       plot(xp,yp,'-r');hold on 
%      
%    end