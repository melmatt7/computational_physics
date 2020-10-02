function x = newtond(f, jacfd, h, x0, tol)
    % f: Function which implements the nonlinear system of equations.
    % Function is of the form f(x) where x is a length-d vector, and
    % returns length-d column vector.
    % jacfd: Function which is of the form jacfd(f, x, h) where f is the above
    % function, x is a length-d vector, and h is the finite difference
    % parameter. jacfd returns the d x d matrix of approximate Jacobian
    % matrix elements.
    % h: Finite differencing parameter.
    % x0: Initial estimate for iteration (length-d column vector).
    % tol: Convergence criterion: routine returns when relative magnitude
    % of update from iteration to iteration is <= tol.

    % x: Estimate of root (length-d column vector)

    fx = f(x0);
    fxNorm = normalize(fx);
    x = x0;
    
    while abs(fxNorm) > tol
        d = jacfd(f, x, h)\(-f(x));
        x = x + d;
        fx = f(x);
        fxNorm = normalize(fx);
    end 
    
    return
end

