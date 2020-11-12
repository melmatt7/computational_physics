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
    x = x0;
    fx = f(x);
    iteration = 1;
    fxNorm(iteration) = norm(fx);
    
    while abs(fxNorm) > tol
        d = jacfd(f, x, h)\(-fx);
        x = x + d;
        fx = f(x);
        fxNorm(iteration) = norm(fx);
        iteration = iteration + 1;
    end
    
    plot(fxNorm)
    
    return
end

