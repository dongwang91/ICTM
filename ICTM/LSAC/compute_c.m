function c = compute_c(I,k,u,b)

[row,col,dim] = size(u);


for i = 1:dim
    KbIu = conv2(b,k,'same').*I.*u(:,:,i);
    Kb2u = conv2(b.^2,k,'same').*u(:,:,i);
    de   = sum(Kb2u(:));
    de   = de+(de==0)*eps;
    c(1:row,1:col,i) = sum(KbIu(:))/de;
end