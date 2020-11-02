y0 = [1; -6];
nt = 2^12 + 1;
tspan = linspace(0, 100, nt);

[tout, yout]   =  rk4(@vanderpol, tspan, y0);

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



function dydt = vanderpol(t, y)
    dydt = [y(2); - y(1) - 5*(y(1)^2 -1)*y(2) ];
end
