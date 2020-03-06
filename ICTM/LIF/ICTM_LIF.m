clc; clear all; close all;
%------------------------------------------------------------------------
% This demo function implements the ICTM method applied into the LIF model.
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
%------------------------------------------------------------------------  


addpath('./image');
flag =5;
switch flag
    case 1
        I = imread('circles.bmp');
        I = double(I(:,:,1));
        I = I(1:2:end,1:2:end);
        iterNum =400;
        lambda1 = 1.0;
        lambda2 = 1.0;
        initialLSF = ones(size(I(:,:,1)))-0.01;
        initialLSF(60:90,60:90) = 0.01;
        tau =5;
        mu = 500;
        sigma=20;
    case 2
        I = imread('3.bmp');
        I = double(I(:,:,1));
        iterNum =300;
        lambda1 = 1.0;
        lambda2 = 1.0;
        tau =5;
        mu = 150;
        sigma=3;
        initialLSF = ones(size(I(:,:,1)))-0.01;
        initialLSF(15:78,32:95) = 0.01;
    case 3
        I = imread('2.bmp');
        I = double(I(:,:,1));
        iterNum =300;
        lambda1 = 1.0;
        lambda2 = 1.0;
        tau =3;
        mu = 245;
        sigma=3;
        initialLSF = ones(size(I(:,:,1)))-0.01;
        initialLSF(26:32,28:34) = 0.01;
    case 4
        I = imread('4.bmp');
        I = double(I(:,:,1));
        iterNum =300;
        lambda1 = 1.0;
        lambda2 = 1.0;
        tau =10;
        mu = 110;
        sigma=3;
        initialLSF = ones(size(I(:,:,1)))-0.01;
        initialLSF(53:77,46:70) = 0.01;
    case 5
        I = imread('5.bmp');
        I = double(I(:,:,1));
        iterNum =300;
        lambda1 = 1.0;
        lambda2 = 1.0;
        tau =2;
        mu = 90;
        sigma=3;
        initialLSF = ones(size(I(:,:,1)))-0.01;
        initialLSF(47:60,86:99) = 0.01;
    case 6
        I = imread('nonHom3.gif');
        I = double(I(:,:,1));
        iterNum =300;
        lambda1 = 1.0;
        lambda2 = 1.0;
        tau =5;
        mu = 50;
        sigma=3;
        initialLSF = ones(size(I(:,:,1)))-0.01;
        initialLSF(30:40,30:40) = 0.01;
        
end

u = initialLSF;

%---------------------------------
Wanttosaveamovie = 1; % Decide to make a video
if Wanttosaveamovie
    filename = ['example-',num2str(flag)];
    Ve = VideoWriter(filename,'MPEG-4');
    FrameRate = max(floor(iterNum/10),1);
    open(Ve);
end
%---------------------------------

%--------------------------------------------------------------------------
if Wanttosaveamovie
    figure;imagesc(I, [0, 255]);colormap(gray);hold on;
    title('Initial contour');
    [c,h] = contour(u,[0.5 0.5],'b','LineWidth',2);
    axis off; axis equal
    hold off;
    currentFrame = getframe(gcf);
    writeVideo(Ve,currentFrame);
end
%--------------------------------------------------------------------------



K=fspecial('gaussian',round(2*sigma)*2+1,sigma);  
K2 = fspecial('gaussian',round(2*tau)*2+1,tau); 
KI=conv2(I,K,'same');                                           
KONE=conv2(ones(size(I)),K,'same');  
                         
                                       

for n=1:iterNum
    Ik=I.*u;
    c1=conv2(u,K,'same');
    c2=conv2(Ik,K,'same');
    f1=(c2)./(c1);
    f2=(KI-c2)./(KONE-c1);
    phi1 = lambda1*conv2(f1.^2,K,'same')-lambda1*2*I.*conv2(f1,K,'same')+mu*conv2(1-u,K2,'same');
    phi2 = lambda2*conv2(f2.^2,K,'same')-lambda2*2*I.*conv2(f2,K,'same')+mu*conv2(u,K2,'same');
    
    u_af = double(phi1-phi2<0)*0.98+0.01;
    change = sum(abs(u_af(:)-u(:)));
    u = u_af;
  
    if change==0
        break;
    end 
    
    
    if Wanttosaveamovie
        imagesc(I, [0, 255]);colormap(gray);hold on;
        [c,h] = contour(phi1-phi2,[0 0],'r','LineWidth',2);
        iterNum=[num2str(n), ' iterations'];
        title(iterNum);hold off;
        axis off; axis equal
        hold off;
        currentFrame = getframe(gcf);
        writeVideo(Ve,currentFrame);
        pause(0.1)
    end   
    
end




if Wanttosaveamovie
    close(Ve)
end