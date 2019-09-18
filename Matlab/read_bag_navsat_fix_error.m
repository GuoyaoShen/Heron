bag = rosbag('2019-09-17-19-00-15.bag');
bag.AvailableTopics;
NFIX = select(bag,'Topic','/navsat/fix');

% plot the la & lo of two bags
la_meter = 111620.2823499694;
lo_meter = 88525.46930879708;

msgStructs = readMessages(NFIX,'DataFormat','struct');
Lo = cellfun(@(m) double(m.Longitude),msgStructs);
La = cellfun(@(m) double(m.Latitude),msgStructs);
Lo_dif = max(Lo) - min(Lo);
La_dif = max(La) - min(La);

Lo_m = Lo * lo_meter;
La_m = La * la_meter;
figure(1);
plot(Lo_m,La_m);
grid on;
xlabel('Longitude(m)');
ylabel('Latitude(m)');
title('Lo&Laplot in meter');

figure(2);
plot(Lo,La);
grid on;
xlabel('Longitude(deg)');
ylabel('Latitude(deg)');
title('Lo&La plot in degree');

m = mean([Lo,La]);
Lo_err = Lo - m(1);
La_err = La - m(2);
figure(3);
plot(Lo_err, La_err,0,0,'r*');
grid on;
xlabel('Longitude(deg)');
ylabel('Latitude(deg)');
title('Lo&La error wrt mean point in degree');

figure(4)
x_err_m = Lo_err * lo_meter;
y_err_m = La_err * la_meter;
plot(x_err_m, y_err_m,0,0,'r*');
grid on;
xlabel('Longitude(m)');
ylabel('Latitude(m)');
title('Lo&La error wrt mean point in meter');