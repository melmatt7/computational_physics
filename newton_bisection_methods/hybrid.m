function x = hybrid(f, dfdx, xmin, xmax, tol1, tol2)
    % f: Function whose root is sought.
    % dfdx: Derivative function.
    % xmin: Initial bracket minimum.
    % xmax: Initial bracket maximum.
    % tol1: Relative convergence criterion for bisection.
    % tol2: Relative convergence criterion for Newton iteration.

    % x: Estimate of root.
    %xmin = round(xmin* 1e5)/ 1e5;
    %xmax = round(xmax* 1e5)/ 1e5;
    intervals = findIntervals(xmin, xmax, f);
    
    if ~(intervals(1) == xmin && intervals(2) == xmax)
        for n = 1 : length(intervals)-1
            xmin_reduced = intervals(n);
            xmax_reduced = intervals(n+1);
            hybrid(f, dfdx, xmin_reduced, xmax_reduced, tol1, tol2)
        end
    end    
    
    x = NaN;    
    if (f(xmin) * f(xmax) > 0)
        return;
    elseif f(xmin) == 0
        x = xmin;
        return
    elseif f(xmax) == 0
        x = xmax;
        return
    end
    
    xmid = (xmin+xmax)/2;
    xhigh = xmax;
    xlow = xmin;

    while abs(f(xmid)) > tol1
        if(f(xlow) * f(xmid)) < 0
          xhigh = xmid;
        else
          xlow = xmid;
        end

        xmid = (xlow + xhigh)/2;
    end
    
    err = 1;
    while err >= tol2 
        y = xmid - (f(xmid)/dfdx(f,xmid));
        err = abs(y-x);
        x=y;
    end
    
    return
end
