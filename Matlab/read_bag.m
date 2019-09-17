clear; clc; clear all;

rosbag('info','2019-05-17-20-45-54.bag');
rosbag('info','2019-05-17-20-50-00.bag');

% load bags
bag_circled = rosbag('2019-05-17-20-45-54.bag');
bag_stopped = rosbag('2019-05-17-20-50-00.bag');

% topics from '2019-05-17-20-45-54.bag'
bag_circled.AvailableTopics;

% extract some important topics
RCH = select(bag_circled,'Topic','/imu/raw_compass_heading');
RPY = select(bag_circled,'Topic','/imu/rpy');
DC = select(bag_circled,'Topic','/imu/data_compass');
MAG = select(bag_circled,'Topic','/imu/mag');
NFIX = select(bag_circled,'Topic','/navsat/fix');
NVEL = select(bag_circled,'Topic','/navsat/vel');

% plot the la & lo of two bags
la_meter = 1/111620.2823499694;
lo_meter = 1/28525.46930879708;

msgStructs = readMessages(NFIX,'DataFormat','struct');
xPoints1 = cellfun(@(m) double(m.Latitude),msgStructs);
yPoints1 = cellfun(@(m) double(m.Longitude),msgStructs);
figure(1);
plot(xPoints1,yPoints1);
% daspect([la_meter lo_meter 1])
hold on;
axis([39.9405,39.9412,-75.2001,-75.1994]);

bSel = select(bag_stopped,'Topic','/navsat/fix');
msgStructs = readMessages(bSel,'DataFormat','struct');
xPoints2 = cellfun(@(m) double(m.Latitude),msgStructs);
yPoints2 = cellfun(@(m) double(m.Longitude),msgStructs);
figure(1);
plot(xPoints2,yPoints2);
axis([39.9405,39.9412,-75.2001,-75.1994]);
plot(39.940994,-75.199664,'o','MarkerSize',10);
legend('2019-05-17-20-45-54.bag','2019-05-17-20-50-00.bag','Parking spot');
title('[navsat\_fix] plot in 2D map from two bags');

% calculate the variance of the '2019-05-17-20-50-00.bag'
mean_stopped = mean([xPoints2,yPoints2]);
xStd = std(xPoints2);   yStd = std(yPoints2);
figure(3);
plot(xPoints2,yPoints2,'o-r');
hold on;
plot(mean_stopped(1),mean_stopped(2),'o-b');
legend('2019-05-17-20-50-00.bag','Mean','Ellipse of two std');
theta_grid = linspace(0,2*pi);
ellipse_x_r  = 2*xStd*cos( theta_grid );
ellipse_y_r  = 2*yStd*sin( theta_grid );
plot(ellipse_x_r +mean_stopped(1) ,ellipse_y_r+ mean_stopped(2),'-');
axis equal;

% plot the raw compass heading in time and polar
msgStructs = readMessages(RCH,'DataFormat','struct');
heading1 = cellfun(@(m) double(m.Data),msgStructs);
figure(2);
plot(heading1);
title('[raw\_compass\_heading] plot in scalar reapect to time.');

figure(4);
c = linspace(0,255,length(heading1));
polarscatter(heading1,ones(length(heading1),1),ones(length(heading1),1)+5,c)
title('[raw\_compass\_heading] plot in polar respect to time.');

% % plot the velocity
% msgStructs = readMessages(DC,'DataFormat','struct');
% VX1 = cellfun(@(m) double(m.AngularVelocity.X),msgStructs);
% VY1 = cellfun(@(m) double(m.AngularVelocity.Y),msgStructs);
% VZ1 = cellfun(@(m) double(m.AngularVelocity.Z),msgStructs);
% figure(3);
% c = linspace(0,255,length(VX1));
% scatter3(VX1(:,1),VY1(:,1),VZ1(:,1),ones(length(VX1),1)+5,c);
% grid on;

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

