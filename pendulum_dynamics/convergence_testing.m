[t6 theta6 omega6]   =  pendulum(tmax, 6, theta0, omega0);
[t7 theta7 omega7]   =  pendulum(tmax, 7, theta0, omega0);
[t8 theta8 omega8]   =  pendulum(tmax, 8, theta0, omega0);
clf; hold on; 
plot(t6, theta6, 'r-.o');
plot(t7, theta7, 'g-.+'); 
plot(t8, theta8, 'b-.*');

theta7 = theta7(1:2:end);
theta8 = theta8(1:4:end);

dtheta67 = theta6 - theta7;
dtheta78 = theta7 - theta8;

clf; hold on; 
plot(t6, dtheta67, 'r-.o'); plot(t6, dtheta78, 'g-.+');

dtheta78 = 4 * dtheta78;
clf; hold on; 
plot(t6, dtheta67, 'r-.o'); plot(t6, dtheta78, 'g-.+');

[t9 theta9 omega9]   =  pendulum(tmax, 9, theta0, omega0);
theta9 = theta9(1:8:length(theta9));
dtheta89 = theta8 - theta9;
dtheta89 = 16 * dtheta89;
plot(t6, dtheta89, 'b-.*'); 