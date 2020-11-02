function dydt = vanderpol(t, y)
    dydt = [y(2); - y(1) - 5*(y(1)^2 -1)*y(2) ];
end

