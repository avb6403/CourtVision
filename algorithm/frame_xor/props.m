clc;
server_ip   = '127.0.0.1';     %IP address of the Unity Server
server_port = 55001;           %Server Port of the Unity Sever

client = tcpclient(server_ip,server_port);

l_pose = [-0.11-0.03,8.66,-2.91,0,0,0];
r_pose = [-0.11+0.03,8.66,-2.91,0,0,0];

img_l = unityLink(client, l_pose);
img_r = unityLink(client, r_pose);

imwrite(img_l, "tennis_l_2.jpg");
imwrite(img_r, "tennis_r_2.jpg");
disp("written");

% viscircles(r.Centroid, (r.MajorAxisLength + r.MinorAxisLength)/(4*sqrt(2)));