reltol_vals = [1.0e-5, 1.0e-7, 1.0e-9, 1.0e-11];
tspan = linspace(0.0, 3.0 * pi, 65);
y0 = [0; 1];
err = zeros(1, 65, length(reltol_vals));
yout = zeros(2, 65, length(reltol_vals));
yexact = sin(tspan);

for i = 1:length(reltol_vals)
    [~, yout(:,:,i)] = rk4ad(@fcn, tspan, reltol_vals(i), y0);
    err(:,:,i) = yout(1,:,i) - yexact;

end

figure(1);
hold all;
fig1(1) = plot(tspan, err(1,:,1), 'r-.+', 'DisplayName', "reltol=1e-5");
fig1(2) = plot(tspan, err(1,:,2), 'g-.+', 'DisplayName', "reltol=1e-7");
xlabel('t'),ylabel('x'),
legend(fig1)
%title("Displacement of Single Mass in Two Body System")
hold off;

figure(2);
hold all;
fig2(1) = plot(tspan, err(1,:,3), 'b-.*', 'DisplayName', "reltol=1e-9");
fig2(2) = plot(tspan, err(1,:,4), 'm-.*', 'DisplayName', "reltol=1e-11");
xlabel('t'),ylabel('x'),
legend(fig2)
%title("Displacement of Single Mass in Two Body System")
hold off;