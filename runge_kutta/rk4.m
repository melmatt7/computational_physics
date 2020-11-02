function [tout, yout] = rk4(fcn, tspan, y0)
    % Inputs
    % fcn: Function handle for right hand sides of ODEs (returns
    % length-n column vector)
    % tspan: Vector of output times (length nout).
    % y0: Initial values (length-n column vector).
    %
    % Outputs
    % tout: Vector of output times.
    % yout: Output values (nout x n array).
    
    tout = tspan;
    yout = zeros(size(y0,1), size(tspan,2));
    yout(:,1) = y0;
    
    for i = 2:length(tspan)
        dt = abs(tspan(i) - tspan(i-1));
        yout(:,i) = rk4step(fcn, tspan(:,i-1), dt, yout(:,i-1));
    end   
    
end

