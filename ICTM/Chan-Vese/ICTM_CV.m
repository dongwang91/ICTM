clc; clear all; close all;
%------------------------------------------------------------------------
% This demo function implements the ICTM method applied into the Chan-Vese model.
% Author: Dong Wang (University of Utah)
% E-mail:dongwang91@gmail.com, dwang@math.utah.edu

%  Notes:
%   1. Please contact the author if any problem regarding the choice of
%   parameters.
%   2. Intial contour should be set properly.
%   3. Ref: Dong Wang and Xiao-Ping Wang, The iterative
%   convolution-thresholding method (ICTM) for image segmentation, 2020.
%
%   Dong Wang, Haohan Li, Xiaoyu Wei, and Xiao-Ping Wang*, 
%   An efficient iterative thresholding method for image segmentation, 
%   J. Comput. Phys., 350, 657-667, 2017.
%------------------------------------------------------------------------  


addpath('./image');
flag =4;
switch flag
    case 1
        I = imread('cameraman.jpg');
        P = rgb2gray(uint8(I));
        P = double(P);
        M = size(I,1);
        N = size(I,2);
        P = P./max(max(abs(P)));
        iterNum =400;
        dt = 0.03;  % time step
        lambda = 0.03;
        lamda = lambda * sqrt(pi)/sqrt(dt);
        u1 = zeros(M,N);
        u1(50:M-50,50:N-50) = ones(M-100+1,N-100+1);
        u2 = ones(M,N)-u1;
        NS = 2; % number of segments
        NC = 1; % number of channels
    case 2     
        I = imread('flowers.jpg');
        M = size(I,1);
        N = size(I,2);
        P = double(I);
        for i = 1:3
            P(:,:,i) = P(:,:,i)./max(max(abs(P(:,:,i))));
        end
        f1 = P(:,:,1); % first color channel
        f2 = P(:,:,2); % second
        f3 = P(:,:,3); % third
        iterNum =300;
        dt = 0.02;
        lambda = 0.05;
        lamda = lambda * sqrt(pi)/sqrt(dt);
        u1 = zeros(M,N);
        u1(50:M-50,50:N-50) = ones(M-100+1,N-100+1);
        u2 = ones(M,N)-u1;    
        NS = 2; % number of segments
        NC = 3; % number of channels
    case 3
        I = imread('circle10242.jpg');
        II(:,:,:) = imnoise(I(:,:,:),'gaussian',0.05,0.05);
        I =II(1:2:end,1:2:end,:);
        M = size(I,1);
        N = size(I,2);
        P = double(I);
        for i = 1:3
            P(:,:,i) = P(:,:,i)./max(max(abs(P(:,:,i))));
        end
        f1 = P(:,:,1); % first color channel
        f2 = P(:,:,2); % second
        f3 = P(:,:,3); % third
        iterNum =300;
        k = 0;
        dt = 0.01;  % time step
        alpha = 0.1;
        lamda = alpha * sqrt(pi)/sqrt(dt);
        u1 = zeros(M,N);
        u1(100:250,80:180) = 1;
        u2 = zeros(M,N);
        u2(350:400,100:400) = 1;
        u3 = zeros(M,N);
        u3(100:150,300:400) = 1;
        u4 = 1 - u1 - u2 - u3;
        NS = 4; % number of segments
        NC = 3; % number of channels
    case 4
        I = imread('circle10242.jpg');
        II(:,:,:) = imnoise(I(:,:,:),'gaussian',0.05,0.05);
        I =II(1:4:end,1:4:end,:);
        M = size(I,1);
        N = size(I,2);
        P = double(I);
        for i = 1:3
            P(:,:,i) = P(:,:,i)./max(max(abs(P(:,:,i))));
        end
        f1 = P(:,:,1); % first color channel
        f2 = P(:,:,2); % second
        f3 = P(:,:,3); % third
        iterNum =300;
        k = 0;
        dt = 0.01;  % time step
        alpha = 0.1;
        lamda = alpha * sqrt(pi)/sqrt(dt);
        u1 = zeros(M,N);
        u1(50:125,40:90) = 1;
        u2 = zeros(M,N);
        u2(175:200,50:200) = 1;
        u3 = zeros(M,N);
        u3(50:75,150:200) = 1;
        u4 = 1 - u1 - u2 - u3;
        NS = 4; % number of segments
        NC = 3; % number of channels
end


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
    imagesc(I, [0, 1]);hold on;
    title('Initial contour');
    if NS==2
    contour(u1,[0.5 0.5],'b','LineWidth',2);
    elseif NS == 3
        contour(u2,[0.5 0.5],'b','LineWidth',2);
    elseif NS == 4
        contour(u2,[0.5 0.5],'b','LineWidth',2);
        contour(u3,[0.5 0.5],'b','LineWidth',2);
    else
        disp('edit the plotting part to validate to your cases')
    end
    axis off; axis equal
    hold off;
    currentFrame = getframe(gcf);
    writeVideo(Ve,currentFrame);
end
%--------------------------------------------------------------------------
change = 1;
                                       
for n=1:iterNum
   
    if NS == 2 && NC ==1
        %------------------------------------------------------------------
        % 2 segments for gray images
        [f1,f2] = daterm(P,u1,u2);
        [uh1,uh2] = HeatConv(dt,u1,u2);
        index1 = f1+lamda*uh2;
        index2 = f2+lamda*uh1;
        u1_af = double(index1<=index2);
        u2_af = 1-u1_af;
        change = sum(abs(u1_af(:)-u1(:)));
        u1 = u1_af;
        u2 = u2_af;
        if Wanttosaveamovie
            imagesc(I, [0, 1]);hold on;
            title('Initial contour');
            contour(u1,[0.5 0.5],'b','LineWidth',2);
            axis off; axis equal
            hold off;
            currentFrame = getframe(gcf);
            writeVideo(Ve,currentFrame);
        end
       
        %------------------------------------------------------------------
    elseif NS == 2 && NC ==3
        %------------------------------------------------------------------
        % 2 segments for color images
        [f11,f21] = daterm(f1,u1,u2); % data term of first color channel
        [f12,f22] = daterm(f2,u1,u2); % data term of second color channel
        [f13,f23] = daterm(f3,u1,u2); % data term of third color channel
        [uh1,uh2] = HeatConv(dt,u1,u2); % heat kernel convolution
        index1 = f11+f12+f13-lamda*uh1;
        index2 = f21+f22+f23-lamda*uh2;
        u1_af = double(index1<=index2); % thresholding if u1>u2 then u1=1 vise versa
        u2_af = 1-u1_af; 
        change = sum(abs(u1_af(:)-u1(:)));
        u1 = u1_af;
        u2 = u2_af;
        if Wanttosaveamovie
            imagesc(I, [0, 1]);hold on;
            title('Initial contour');
            contour(u1,[0.5 0.5],'k','LineWidth',2);
            axis off; axis equal
            hold off;
            currentFrame = getframe(gcf);
            writeVideo(Ve,currentFrame);
        end
        %------------------------------------------------------------------
    elseif NS == 4 && NC ==3
        %------------------------------------------------------------------
        % 4 segments for color images
        [f11,f21,f31,f41] = daterm(f1,u1,u2,u3,u4); % data term of first color channel
        [f12,f22,f32,f42] = daterm(f2,u1,u2,u3,u4); % data term of second color channel
        [f13,f23,f33,f43] = daterm(f3,u1,u2,u3,u4); % data term of third color channel
        [uh1,uh2,uh3,uh4] = HeatConv(dt,u1,u2,u3,u4); % heat kernel convolution
        index1 = f11+f12+f13-lamda*uh1;
        index2 = f21+f22+f23-lamda*uh2;
        index3 = f31+f32+f33-lamda*uh3;
        index4 = f41+f42+f43-lamda*uh4;
        
        % -- thresholding: if ui is the largest value then ui=1 and
        % uj=0 for j!=i
        u1_af = double(index1<=index2).*double(index1<=index3).*double(index1<=index4);
        u2_af = double(index2<index1).*double(index2<=index3).*double(index2<=index4).*double(u1==0);
        u3_af = double(index3<index1).*double(index3<index2).*double(index3<=index4).*double(u2==0).*double(u1==0);
        u4_af = 1-u1_af-u2_af-u3_af;
        change = norm(u1-u1_af) + norm(u2-u2_af) + norm(u3-u3_af);
        u1 = u1_af;
        u2 = u2_af;
        u3 = u3_af;
        u4 = u4_af;
                    
        if Wanttosaveamovie
            imagesc(I, [0, 1]);hold on;
            title('Initial contour');
            contour(u1,[0.5 0.5],'k','LineWidth',2);
            contour(u2,[0.5 0.5],'k','LineWidth',2);
            contour(u3,[0.5 0.5],'k','LineWidth',2);
            
            axis off; axis equal
            hold off;
            currentFrame = getframe(gcf);
            writeVideo(Ve,currentFrame);
        end
        %------------------------------------------------------------------
    end
    
    
    
  
    if change==0
        break;
    end 
    
    
   
    
end



if Wanttosaveamovie
    close(Ve)
end