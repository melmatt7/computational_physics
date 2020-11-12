tmax = 40; level = 8; theta0 = 0;

for omega0 = [0.1 0.3 1.0 1.5 1.9]
  [t theta omega]   =  pendulum(tmax, level, theta0, omega0);
  [t ltheta lomega] = lpendulum(tmax, level, theta0, omega0);
  clf; hold on; ptitle = sprintf('omega_0 = %g',omega0); 
  plot(t, theta, 'r'); plot(t, ltheta, '-.og');
  title(ptitle);
  input('Type ENTER to continue: ');
  clf; hold on; ptitle = sprintf('Phase space plot: omega_0 = %g',omega0);
  plot(theta, omega, 'r'); plot(ltheta, lomega, '-.og'); 
  title(ptitle);
  xlabel('theta');
  ylabel('omega');
  input('Type ENTER to continue: ');
end

omega0 = 2.05;
[t theta omega]   =  pendulum(tmax, level, theta0, omega0);
clf; plot(t,theta,'r');

[t thetalo omegalo]   =  pendulum(tmax, level, theta0, 1.9);
[t thetahi omegahi]   =  pendulum(tmax, level, theta0, 2.05);
clf; hold on;
plot(t, thetalo, 'g'); plot(t, thetahi, 'r');
title('"low" and "high" behaviour');