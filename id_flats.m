salami=zeros(size(xc));%flats are called salami. 
b5=unique(scarps(find(scarps>0)));

%Step 5
counts=1;
if ~isempty(b5)
for i=1:length(b5)+1
if i==1 
    b=xc(find(scarps==b5(i))); 
    a=find(slope<scarp_slope &xc'>0&xc'<min(b));
 elseif i==length(b5)+1
    b=xc(find(scarps==b5(i-1)));
    a=find(slope<scarp_slope &xc'>max(b));
    else
    b=xc(find(scarps==b5(i-1))); 
    b1=xc(find(scarps==b5(i))); 
    a=find(slope<scarp_slope &xc'>max(b)&xc'<min(b1));
end
if  max(xc(a))-min(xc(a))>scarp_dist/2
    salami(a)=counts;
    counts=counts+1;
end
end

end