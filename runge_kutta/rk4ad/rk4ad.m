function [tout, yout] = rk4ad(fcn, tspan, reltol, y0)
    % Inputs
    % fcn: Function handle for right hand sides of ODEs (returns
    % length-n column vector)
    % tspan: Vector of output times (length nout vector).
    % reltol: Relative tolerance parameter.
    % y0: Initial values (length-n column vector).
    %
    % Outputs
    % tout: Output times (length-nout column vector, elements
    % identical to tspan).
    % yout: Output values (nout x n array).
    
    
    tout = tspan;
    yout = zeros(size(y0,1), size(tspan,2));
    yout(:,1) = y0;
    dtspan = tspan(2) - tspan(1);
    
    for i = 2:length(tspan)
        curr_t = tspan(i-1);
        next_t = tspan(i);
        curr_y = yout(:,i-1);
        
        % loop to ensure only solution values corresponding 
        % to the times in the tspan array are output
        while curr_t < next_t
            dt = next_t - curr_t;
                        
            [yC, eC] = local_err(fcn, curr_t, dt, curr_y);

            % loop to determine appropriate dt for 
            % interval curr_t -> curr_t + dt
            while eC > reltol
                dt =  dtspan*abs(reltol/eC)^(0.7);
                if dt < 1.0e-4
                    dt = 1.0e-4;
                end                
                
                [yC, eC] = local_err(fcn, curr_t, dt, curr_y);
            end
            curr_y = yC;
            curr_t = curr_t + dt;
        end
        yout(:,i) = yC;
    end  
end

function [yC, eC] = local_err(fcn, curr_t, dt, curr_y)
    yC = rk4step(fcn, curr_t, dt, curr_y);

    yFmid = rk4step(fcn, curr_t, dt/2, curr_y);
    yF = rk4step(fcn, curr_t, dt/2, yFmid);

    eC = 16/15*abs(yC(1) - yF(1));
end

