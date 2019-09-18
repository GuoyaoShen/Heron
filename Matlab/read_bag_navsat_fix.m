% rosbag('info','2019-09-17-17-55-55.bag');

bag_circled = rosbag('2019-09-17-19-00-15.bag');
bag_circled.AvailableTopics;

NFIX = select(bag_circled,'Topic','/navsat/fix');

% plot the la & lo of two bags
% ref: http://www.csgnetwork.com/degreelenllavcalc.html
la_meter = 111034.61;
lo_meter = 85393.83;

msgStructs = readMessages(NFIX,'DataFormat','struct');
Lo = cellfun(@(m) double(m.Longitude),msgStructs);
La = cellfun(@(m) double(m.Latitude),msgStructs);
x_dif = max(Lo) - min(Lo);
y_dif = max(La) - min(La);

figure(1);
Lo_m = Lo * lo_meter;
La_m = La * la_meter;
plot(Lo_m,La_m);
xlabel('Longitude (meter)');
ylabel('Latitude (meter)');

figure(2);
plot(Lo,La)
xlabel('Longitude (deg)');
ylabel('Latitude (deg)');
