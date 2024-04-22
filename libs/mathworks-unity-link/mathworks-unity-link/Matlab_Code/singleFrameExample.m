clc;
clear all;
close all;

%Include source files in path
addpath(genpath('../src'))

%Initialization Parameters
server_ip   = '127.0.0.1';     %IP address of the Unity Server
server_port = 55001;           %Server Port of the Unity Sever

client = tcpclient(server_ip,server_port);
fprintf(1,"Connected to server\n");
A=[];
I=[];
%for i = 0.5:0.125:3
for i= 0.5:0.125:3.875
    disp(i)
    i

% x,y,z,yaw[z],pitch[y],roll[x]
pose = [-2,1+i,1.97,180,-90,90];
unityImageRight = unityLink(client,pose);
subplot(1,2,1);
imshow(unityImageRight);

% x,y,z,yaw[z],pitch[y],roll[x]
% shift between cameras is 60mm, so +- 0.03 units (meters)
% camera is 2 meters above the court currently
% ball is at (-2,2)
pose = [-2,1+i,2.03,180,-90,90];
unityImageLeft = unityLink(client,pose);
subplot(1,2,2);
imshow(unityImageLeft);


rightim2 = unityImageRight;
leftim2 = unityImageLeft;


grayleft = rgb2gray(leftim2);
grayright = rgb2gray(rightim2);



%grayright = imbilatfilt(grayright);
grayright = (grayright-100)*2.5;
grayleft = (grayleft-100)*2.5;

centersleft=[];
radiileft=[];
centersright=[];
radiiright=[];

if(i<2.5) 

    grayright = edge(grayright,"Canny",0.4);
    grayleft = edge(grayleft,"Canny",0.4);

%low = 0.1;
%high = 0.9;
%grayright = imadjust(I,[low high],[]); % I is double

%regionprops(grayleft)



[centersleft,radiileft] = imfindcircles(grayleft,[6 100],"ObjectPolarity","dark","Sensitivity",0.8);
[centersright,radiiright] = imfindcircles(grayright,[6 100],"ObjectPolarity","dark","Sensitivity",0.8);
else 

[centersleft,radiileft] = imfindcircles(grayleft,[6 60],"ObjectPolarity","bright","Sensitivity",0.8);
[centersright,radiiright] = imfindcircles(grayright,[6 60],"ObjectPolarity","bright","Sensitivity",0.8);

end 
   

subplot(2,2,1);
imshow(grayleft);

hl = viscircles(centersleft,radiileft);
centroidleft = centersleft;
%175

subplot(2,2,2);

imshow(grayright);
%imadjust(I)
%imcontrast
hr = viscircles(centersright,radiiright);
centroidright = centersright;

%Close Gracefully

  x1=centroidright(1);
            y1=centroidright(2);

            x2=centroidleft(1);
            y2=centroidleft(2);

            b = 60;                 % baseline [mm]
            f = 6;                  % focal length [mm]
            pixelSize = .006;       % pixel size [mm]
            xNumPix = 752;          % total number of pixels in x direction of the sensor [px]
            cxLeft = xNumPix/2;     % left camera x center [px]
            cxRight = xNumPix/2;    % right camera x center [px]


            yNumPix = 480;          % total number of pixels in y direction of the sensor [px]
            cyLeft = yNumPix/2;     % left camera y center [py]
            cyRight = yNumPix/2;    % right camera y center [py]

            d = (abs((x1-cxLeft)-(x2-cxRight))*pixelSize); % disparity
            Z = (b * f) / d;          % depth
            X = (Z * (x1-cxLeft)*pixelSize)/f;
            Y = (Z * (y1-cyLeft)*pixelSize)/f;

            disp('coordinates in m:')
            disp('x')
               disp(X/1000)
               disp('y')
               disp(Y/1000)
               disp('z')
               disp(Z/1000)
            disp(i)
        A=[A,Z/1000]; % calculated Z
        I=[I,i]; % actual Z is i-1
end
scatter(I,(A-I))
hold on
scatter(I,A) 
hold on
legend('actual')
scatter(I,I)

fprintf(1,"Disconnected from server\n");
