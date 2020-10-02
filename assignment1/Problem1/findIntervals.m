function [intervals] = findIntervals(xmin, xmax, f)
    % xmin: minimum value to return local extrema for
    % xmax: maximum value to return local extrema for
    % f: function for which to calculate appropriate extrema  
    
    syms x
    assume(x, 'real')
    
    g = diff(f(x), x);
    max_deg = feval(symengine, 'degree', f(x), x);
  
    extrema = sort(vpa(solve(g == 0, x, 'MaxDegree', max_deg+1), 6));
    rel_extrema = extrema(extrema>xmin & extrema<xmax);
    intervals = [xmin; rel_extrema; xmax];
end

