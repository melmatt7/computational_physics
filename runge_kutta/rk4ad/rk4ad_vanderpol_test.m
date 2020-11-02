clf
hold on

addpath('..')
addpath('../rk4step')

y0 = [1; -6];
reltol = 1.0e-10;
tspan = linspace(0.0, 100, 4097);

[tout, yout] = rk4ad(@vanderpol, tspan, reltol, y0);

figure(1);
hold all;
fig1(1) = plot(tout, yout(1,:), 'r-.o');
xlabel('t'),ylabel('x(t)')
%legend(fig1)
%title("Displacement of Single Mass in Two Body System")
hold off;

figure(2);
hold all;
fig2(1) = plot(yout(1,:), yout(2,:), 'r-.o');
xlabel('x(t)'),ylabel('p(t)')
%legend(fig2)
%title("Scaled Level Error")
hold off;