function [f1,f2,f3,f4,f5,f6] = daterm(f,u1,u2,u3,u4,u5,u6)

c1 = sum(sum(u1.*f))/sum(sum(u1));
c2 = sum(sum(u2.*f))/sum(sum(u2));

f1 = (f-c1).^2;  
f2 = (f-c2).^2;
if nargin ==4 
    f3 = ((f-sum(sum(u3.*f))/sum(sum(u3)))).^2;
elseif nargin ==5 
    f3 = ((f-sum(sum(u3.*f))/sum(sum(u3)))).^2;
    f4 = ((f-sum(sum(u4.*f))/sum(sum(u4)))).^2;
elseif nargin ==6
    f3 = ((f-sum(sum(u3.*f))/sum(sum(u3)))).^2;
    f4 = ((f-sum(sum(u4.*f))/sum(sum(u4)))).^2;
    f5 = ((f-sum(sum(u5.*f))/sum(sum(u5)))).^2;
elseif nargin ==7 
    f3 = ((f-sum(sum(u3.*f))/sum(sum(u3)))).^2;
    f4 = ((f-sum(sum(u4.*f))/sum(sum(u4)))).^2;
    f5 = ((f-sum(sum(u5.*f))/sum(sum(u5)))).^2;
    f6 = ((f-sum(sum(u6.*f))/sum(sum(u6)))).^2;
end 
end




