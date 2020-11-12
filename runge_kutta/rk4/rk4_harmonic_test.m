clf
hold on

addpath('..')
addpath('../rk4step')

y0 = [0; 1];

[t6, y6]   =  rk4(@fcn, linspace(0, 3*pi, 2^6 + 1), y0);
[t7, y7]   =  rk4(@fcn, linspace(0, 3*pi, 2^7 + 1), y0);
[t8, y8]   =  rk4(@fcn, linspace(0, 3*pi, 2^8 + 1), y0);

figure(1);
hold all;
fig1(1) = plot(t6, y6(1,:), 'r-.o', 'DisplayName', "level 6");
fig1(2) = plot(t7, y7(1,:), 'g-.+', 'DisplayName', "level 7");
fig1(3) = plot(t8, y8(1,:), 'b-.*', 'DisplayName', "level 8");
xlabel('t'),ylabel('x(t)')
legend(fig1)
hold off;

y7 = y7(:, 1:2:end);
err67 = y6 - y7;

y8 = y8(:, 1:4:end);
err78 = y7 - y8;

figure(2);
hold all;
fig2(1) = plot(t6, err67(1,:), 'r-.o','DisplayName', "level 6-7");
fig2(2) = plot(t6, 4^2*err78(1,:), 'g-.+','DisplayName', "16(level 7-8)");
xlabel('t'),ylabel('error')
legend(fig2)
hold off;