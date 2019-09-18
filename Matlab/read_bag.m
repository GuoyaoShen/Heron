clear; clc; clear all;

% Change to your file's name
rosbag('info','2019-05-17-20-45-54.bag');

% load bags
bag = rosbag('2019-05-17-20-45-54.bag');

% topics from the .bag
bag.AvailableTopics;

% extract some important topics from Heron
RCH = select(bag,'Topic','/imu/raw_compass_heading');
RPY = select(bag,'Topic','/imu/rpy');
DC = select(bag,'Topic','/imu/data_compass');
MAG = select(bag,'Topic','/imu/mag');
NFIX = select(bag,'Topic','/navsat/fix');
NVEL = select(bag,'Topic','/navsat/vel');

% Parameter will later used to transform lo&la to meter
% ref: http://www.csgnetwork.com/degreelenllavcalc.html
la_meter = 111034.61;
lo_meter = 85393.83;

% Get the latitude and longitude from rostopic: /navsat/fix
msgStructs = readMessages(NFIX,'DataFormat','struct');
Lo = cellfun(@(m) double(m.Longitude),msgStructs);
La = cellfun(@(m) double(m.Latitude),msgStructs);

% Plot the data
figure(1);
plot(Lo,La);
hold on;
xlabel('Longitude(deg)');
ylabel('Latitude(deg)');
% axis([39.9405,39.9412,-75.2001,-75.1994]);

% plot the linear velocity
msgStructs = readMessages(NVEL,'DataFormat','struct');
VX2 = cellfun(@(m) double(m.Twist.Linear.X),msgStructs);
VY2 = cellfun(@(m) double(m.Twist.Linear.Y),msgStructs);
VZ2 = cellfun(@(m) double(m.Twist.Linear.Z),msgStructs);
figure(5)
c = linspace(0,255,length(VX2));
scatter3(VX2(:,1),VY2(:,1),VZ2(:,1),ones(length(VX2),1)+5,c);
title('[navsat\_vel.Twist.Linear] plot respect to time.')
axis equal

% plot the intergate of linear velocity
t = cellfun(@(m) double(m.Header.Stamp.Sec), msgStructs);
nt = cellfun(@(m) double(m.Header.Stamp.Nsec), msgStructs);

X(1) = 0; Y(1) = 0;
for i=1:length(t)-1
    T(i) = t(i) + nt(i)*1e-9 - t(i+1) - nt(i+1)*1e-9;
    X(i+1) = X(i) + VX2(i) * T(i);
    Y(i+1) = Y(i) + VY2(i) * T(i);
end

figure(6);
scatter(X,Y,ones(length(X),1)+5, linspace(0,255,length(X)));
title('[navsat\_vel.Twist.Linear] integration by time stamp.')
axis equal

