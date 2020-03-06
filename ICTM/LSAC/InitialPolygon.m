function [phi] = InitialPolygon(n,m)

k = 10;
N2 = n*m;
x = 1:n;
y = 1:m;
[X,Y] = meshgrid(y,x);
ind = randi(N2,k-1,1);
ind = [floor(n*m/2+n/2);ind];
XY = [X(:),Y(:)]; XY2 = [X(ind),Y(ind)];
D =  bsxfun(@plus, dot(XY,XY,2), dot(XY2,XY2,2)') - 2*(XY*XY2');
[~,labs] = min(D,[],2);

u = zeros(n,n,m);

for ii = 1:N2
    [I,J] = ind2sub([n,m],ii);
    u(labs(ii),I,J)=1;
end

phi(:,:) = u(1,:,:);