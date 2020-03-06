function sigma = compute_s(I,b,k,c,u)
% simag is variance.

 [row,col,dim] = size(c);
 I2 = I.^2;
 for i = 1:dim
     KuI2 = conv2(u(:,:,i).*I2,k,'same');
     bc = b.*(c(:,:,i));
     bcKuI = -2*bc.*conv2(u(:,:,i).*I,k,'same');
     bc2Ku = bc.^2.*conv2(u(:,:,i),k,'same');
     nu = sum(sum(KuI2+bcKuI+bc2Ku));
     ku = conv2(u(:,:,i),k,'same');
     d =  sum(ku(:));
     d  = d + (d==0)*eps;
     sigma(1:row,1:col,i) = nu/d;
 end
    


 
 
 


 