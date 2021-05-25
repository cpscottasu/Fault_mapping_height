a=unique(salami(find(salami>0)));
for i=1:length(a)-1
 h=find(salami==a(i));x1=xc(h);z1=zc(h);  
 h=find(salami==a(i+1));x2=xc(h);z2=zc(h);    
 if ~isempty(z1)&~isempty(z2)
 g=[[x1;zeros(size(x2))] [zeros(size(x1));x2] [ones(size(x1));zeros(size(x2))]  [zeros(size(x1));ones(size(x2))] ];
 m=inv(g'*g)*g'*double([z1;z2]);%Fit lines to the flats. 
 pred=g*m;
 b=find(xc>max(x2)-20&xc<min(x1)+20);flip=1;
 if isempty(b)
  b=find(xc>max(x1)+1&xc<min(x2)-1);   flip=-1;
 end
 c1=find(slope(b)==max(slope(b)));
 x_fault=mean(xc(b(c1)));
 
 c1=find(zc(b)==max(zc(b)));
 x_fault_top=mean(xc(b(c1)));
 z_fault_top=mean(zc(b(c1)));
 
 c1=find(zc(b)==min(zc(b)));
 x_fault_bottom=mean(xc(b(c1)));
 z_fault_bottom=mean(zc(b(c1)));
 
 height=flip*((m(1)*x_fault+m(3))-(m(2)*x_fault+m(4)));%project lines to the fault to calculate the slope. 
 
 if plot_yes==1
 plot([x1;x2],pred,'c.','MarkerSize',13);hold on 
 
 
 plot(x_fault*[1 1],[(m(1)*x_fault+m(3)) (m(2)*x_fault+m(4))],'-r','LineWidth',3)
 
 
 %plot(x_fault_top*[1 1]/1e3,ylim,'-r')
text(x_fault,double((z_fault_top+z_fault_bottom)/2),[num2str(round(height,1)),' m'],'FontSize',14)
 end
 if ~isnan(height)
     heights_fault(p2,:)=[scarp_slope scarp_dist slope_dist swath_width x_fault+min(x(c)) x_fault_bottom+min(x(c)) x_fault_top+min(x(c)) t height max(slope(b))];
     p2=p2+1;
 end
end
end
% axis equal