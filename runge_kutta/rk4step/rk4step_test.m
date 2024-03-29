clf
hold on

addpath('..')

y0 = [0; 1];
t0 = 0;
dt = [0.1 0.05 0.025 0.0125];
err = zeros(size(dt));

for i = 1:4
    yout = rk4step(@fcn, t0, dt(i), y0);
    yexact = y0(1)*cos(t0+dt(i)) + y0(2)*sin(t0+dt(i));
    err(i) = abs(yexact - yout(1));
end

% The following three values result close to 2^5=32 verifying the rk4step
% is performing as expected for a variety of step sizes
R(1) = err(1)/err(2);
R(2) = err(2)/err(3);
R(3) = err(3)/err(4);

R

plot(dt,err)
xlabel('step size'),ylabel('error')