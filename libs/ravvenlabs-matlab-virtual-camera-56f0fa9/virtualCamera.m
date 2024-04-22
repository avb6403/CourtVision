% Dr. Kaputa
% Synthetic Camera Demo
% must run matlabStereoServer.py first on the FPGA SoC

width = 752;
height = 480;

%Initialization Parameters
server_ip   = '192.168.2.19';     % IP address of the server
server_port = 9999;               % Server Port of the sever

client = tcpclient(server_ip,server_port);
fprintf(1,"Connected to server\n");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% send raw frames
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
write(client,'0');
flush(client);
data = imread('sailboat.jpg');
data = uint8(data);
dataGray = im2gray(data);
imageStack = uint8(ones(height,width,8));
imageStack(:,:,1:3) = data;
imageStack(:,:,5:7) = data;
imageStack(:,:,4) = dataGray;
imageStack(:,:,8) = dataGray;
imageStack = permute(imageStack,[3 2 1]);
write(client,imageStack(:));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% receive processed frames
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
write(client,'2');
flush(client);
dataLeft = read(client,width*height);   
temp = reshape(dataLeft,[width,height]);
leftProcessed = permute(temp,[2 1]);
dataRight = read(client,width*height);
temp = reshape(dataRight,[width,height]);
rightProcessed = permute(temp,[2 1]);

t = tiledlayout(1,2, 'Padding', 'none', 'TileSpacing', 'compact'); 
t.TileSpacing = 'compact';
t.Padding = 'compact';
 
nexttile    
imagesc(data)
axis off
nexttile
imagesc(leftProcessed);
colormap gray
axis off