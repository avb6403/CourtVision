% hold code
clc;
clear all;
close all;

%Initialization Parameters
server_ip   = '127.0.0.1';     %IP address of the Unity Server
server_port = 55001;           %Server Port of the Unity Sever

client = tcpclient(server_ip,server_port);
fprintf(1,"Connected to server\n");

b = 500;                 % baseline [mm]
bShiftM = 30;                 %(b/1000)/2
f = 6;                  % focal length [mm]
ps = .006;              % pixel size [mm]
xNumPix = 752;          % total number of pixels in x direction of the sensor [px]
yNumPix = 480;          % total number of pixels in y direction of the sensor [px]
cxLeft = xNumPix/2;     % left camera x center [px]
cyLeft = yNumPix/2;     % left camera y center [px]
cxRight = xNumPix/2;    % right camera x center [px]
cyRight = yNumPix/2;    % right camera y center [px]


serve = readmatrix("serve1.dat");

figure

courtWidth = 8.23;
courtLength = 23.77;

counter = 1;
y = 0;
z = 0;
for index = 1:10:400
    x = serve(index,1);
    y = serve(index,2);
    z = serve(index,3);
   
    y = y + 1;

    xActual(counter) = x;
    yActual(counter) = y;
    zActual(counter) = z;
    % move ball
    % z,x,y, y rot, x rot, z rot
    pose = [x,z,-y,0,0,0,3];
    unityImage = unityLink(client,pose);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % left camera
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % z,x,y, y rot, x rot, z rot
    pose = [0,0,bShiftM,0,90,90,1];
    unityImageLeft = unityLink(client,pose);
    gray = rgb2gray(unityImageLeft);
    bw = im2bw(gray,.5);
    s = regionprops(bw,'centroid');
    leftCentroid = s.Centroid;
    
    subplot(1,2,1)
    imshow(bw);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % right camera
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % z,x,y, y rot, x rot, z rot
    %
    pose = [0,0.5,bShiftM,0,90,90,2];
    unityImageRight = unityLink(client,pose);
    
    gray = rgb2gray(unityImageRight);
    bw = im2bw(gray,.5);
    s = regionprops(bw,'centroid');
    rightCentroid = s.Centroid;
    
    subplot(1,2,2)
    imshow(unityImageRight);
    
    %Close Gracefully
    fprintf(1,"Disconnected from server\n");
    
    % you will ask the user for these values in your python code
    xLeft = leftCentroid(1);
    yLeft = leftCentroid(2);
    xRight = rightCentroid(1);
    yRight = rightCentroid(2);

    d = (abs((xLeft-cxLeft)-(xRight-cxRight))*ps);  % disparity [mm]
    Z = (b * f)/d;                                  % depth [mm]
    X = (Z * (xLeft-cxLeft) * ps)/f;
    Y = (Z * (yLeft-cyLeft) * ps)/f;
    xMeasured(counter) = X/1000;
    zMeasured(counter) = -Y/1000;
    yMeasured(counter) = 35-(Z/1000);
    counter = counter + 1;
end

figure
scatter3(xActual,zActual,yActual)
hold on
scatter3(zMeasured,xMeasured,yMeasured)