function [b,c,d] = sigma_1norm(data)
a=sort(data);
b=a(round(.16*length(a)));
c=a(round(.5*length(a)));
d=a(round(.84*length(a)));

end

