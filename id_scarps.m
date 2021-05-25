
%find x coordinate that belong to the fault. 
scarps_pieces=zeros(ceil(max(xc)),1);
scarp_num=1;
for i=round(scarp_dist/2):max(xc)-round(scarp_dist/2)
    d=find(xc>i-scarp_dist/2&xc<i+scarp_dist/2);
    if abs(mean(slope(d)))>=scarp_slope; 
scarps_pieces(i)=scarp_num;

    else
        scarp_num=scarp_num+1;
    end
end

%Step 4: Find data points that are scarps  
b5=unique(scarps_pieces(find(scarps_pieces>0)));
scarps=zeros(size(zc));
for i=1:length(b5);
    b1=min(find(scarps_pieces==b5(i)));
     b2=max(find(scarps_pieces==b5(i)));
    f=find(xc>b1&xc<b2);  
    scarps(f)=b5(i);
end
 

