clc; clear all; close all;
%------------------------------------
% This demo function implements the ICTM method applied into the LSAC
% model. 
% Author: Dong Wang (University of Utah)
% E-mail:dongwang91@gmail.com, dwang@math.utah.edu

%  Notes:
%   1. Please contact the author if any problem regarding the choice of
%   parameters.
%   2. Intial contour should be set properly.
%   3. Ref: Dong Wang and Xiao-Ping Wang, The iterative
%   convolution-thresholding method (ICTM) for image segmentation.
%
%   Dong Wang, Haohan Li, Xiaoyu Wei, and Xiao-Ping Wang*, 
%   An efficient iterative thresholding method for image segmentation, 
%   J. Comput. Phys., 350, 657-667, 2017.
%
%   4. Sub functions ``computed_b,_c,_s,_d'' can be refered to Lei Zhang's
%   software at http://www4.comp.polyu.edu.hk/~cskhzhang/.


addpath('./image');
flag =2;
switch flag
    case 1
        I = imread('noisyNonUniform.bmp'); % for 3t MRI
        I = double(I(:,:,1));
        [nrow,ncol] = size(I);
        ic = nrow/2;
        jc = ncol/2;
        r  = 20;
        sigma = 5;
        Iternum = 300; 
        tau = 0.03;
        gamma = 0.26/sqrt(pi);
    case 2
        I = imread('nonHom3.gif');
        I = double(I(:,:,1));
        [nrow,ncol] = size(I);
        ic = nrow/2;
        jc = ncol/2;
        r  = 20;
        sigma = 15;
        Iternum = 60; 
        tau = 0.02;
        gamma = 0.1/sqrt(pi);
    case 3
        I = imread('vessel3.bmp'); 
        I = double(I(:,:,1));
        [nrow,ncol] = size(I);
        ic = 80;
        jc = 90;
        r  = 20;
        sigma = 10;
        Iternum = 300;
        tau = 0.03;
        gamma = 0.7/sqrt(pi);
    case 4
        I = imread('f95.bmp'); 
        I = double(I(:,:,1));
        [nrow,ncol] = size(I);
        ic = nrow/2;
        jc = ncol/2;
        r  = 20;
        sigma = 10;
        Iternum = 700;  
        tau = 0.01;
        gamma = 0.002/sqrt(pi);
    case 5
        I = imread('T2.bmp'); 
        I = double(I(:,:,1));
        [nrow,ncol] = size(I);
        ic = nrow/2;
        jc = ncol/2;
        r  = 20;
        sigma  = 10;
        Iternum = 300; 
        tau = 0.002;
        gamma = 0.035/sqrt(pi);
    case 6
        I = imread('1.bmp');
        I = double(I(:,:,1));
        [nrow,ncol] = size(I);
        ic = nrow/2;
        jc = ncol/2;
        r  = 15;
        sigma = 15;
        Iternum = 10;
        tau = 0.01;
        gamma = 0.1;
    case 7
        I = imread('2.bmp');
        I = double(I(:,:,1));
        [nrow,ncol] = size(I);
        ic = nrow/2;
        jc = ncol/2;
        r  = 15;
        sigma = 15;
        Iternum = 10;
        tau = 0.01;
        gamma = 0.1;
    case 8
        I = imread('3.bmp');
        I = double(I(:,:,1));
        [nrow,ncol] = size(I);
        ic = nrow/2;
        jc = ncol/2;
        r  = 15;
        sigma = 15;
        Iternum = 10;
        tau = 0.01;
        gamma = 0.1;
    case 9
        I = imread('4.bmp');
        I = double(I(:,:,1));
        [nrow,ncol] = size(I);
        ic = nrow/2;
        jc = ncol/2;
        r  = 15;
        sigma = 15;
        Iternum = 10;
        tau = 0.01;
        gamma = 0.1;
    case 10
        I = imread('5.bmp');
        I = double(I(:,:,1));
        [nrow,ncol] = size(I);
        ic = nrow/2;
        jc = ncol/2;
        r  = 15;
        sigma = 20;
        Iternum = 10;
        tau = 0.01;
        gamma = 0.1;
        
end
%--------------------------------------------------------------------------
K = 1/(2*sigma+1)/(2*sigma+1)*ones(2*sigma+1);%The constant kerenl with a small size
KF = meshgrid(-nrow/2:1:nrow/2-1,-ncol/2:ncol/2-1)';
KF = fftshift(exp(-KF.^2*tau)); % Fourier transform of Heat kernel
%--------------------------------------------------------------------------


dim = 2; % two phase model


%Parameter initialization
b(1:nrow,1:ncol) = 1;
for i = 1:dim
    s(1:nrow,1:ncol,i) = i;
end
%--------------------------------- Initialization
phi = sdf2circle(nrow,ncol, ic,jc,r); 
%---------------------------------


%--------------------------------- Another initialization
% [phi] = InitialPolygon(nrow,ncol);
% phi = phi-1/2;
%---------------------------------

%---------------------------------
Wanttosaveamovie = 1; % Decide to make a video
if Wanttosaveamovie
    filename = ['example-',num2str(flag)];
    Ve = VideoWriter(filename,'MPEG-4');
    FrameRate = max(floor(Iternum/10),1);
    open(Ve);
end
%---------------------------------



%--------------------------------------------------------------------------
if Wanttosaveamovie
    figure;imagesc(I, [0, 255]);colormap(gray);hold on; axis off;
    title('Initial contour');
    [c,h] = contour(phi,[0 0],'b','LineWidth',2);
    axis off; axis equal
    hold off;
    currentFrame = getframe(gcf);
    writeVideo(Ve,currentFrame);
end
%--------------------------------------------------------------------------

%---------------------------------
phi0 = 0;
u(:,:,1) = double(phi<0);
u(:,:,2) = 1-u(:,:,1);
phi(:,:) = u(:,:,1);
Energy = zeros(1,1);
%---------------------------------

tic;
for i = 1:Iternum
    c = compute_c(I,K,u,b);
    b = compute_b(I,K,u,c,s);
    s = compute_s(I,b,K,c,u); 
    d = computer_d(I,K,s,b,c);
    phidiff2 = ifft2(KF.*fft2(phi));    
    phi = double((d(:,:,1)+sqrt(pi)*gamma/sqrt(tau)*(1-2*phidiff2))<d(:,:,2));
    change = sum((phi(:)-phi0(:)).^2);
    if change < 1
        break;
    end
    phi0 = phi;
    u(:,:,1) = phi;
    u(:,:,2) = 1-phi;
    
%-----------------------------------
if Wanttosaveamovie
    imagesc(I,[0 255]);colormap(gray)
    hold on;
    contour(phi,[0.5 0.5],'r','LineWidth',2);
    iterNum=[num2str(i), ' iterations'];
    title(iterNum);hold off;
    axis off
    axis equal
    currentFrame = getframe(gcf);
    writeVideo(Ve,currentFrame);
end
%-----------------------------------

    
end

toc;


if Wanttosaveamovie
    close(Ve)
end
