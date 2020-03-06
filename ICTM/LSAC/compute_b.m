function b = compute_b(I,k,u,c,sigma)

[row,col,dim] = size(u);

J1 = zeros(row,col);
J2 = zeros(row,col);

for i = 1:dim
    
    csi = c(:,:,i)./sigma(:,:,i);
    c2si = c(:,:,i).^2./sigma(:,:,i);
    
    J1 = J1 + conv2(I.*u(:,:,i),k,'same').*csi;
    J2 = J2 + conv2(u(:,:,i),k,'same').*c2si;
end

b = J1./(J2+(J2==0).*eps);
