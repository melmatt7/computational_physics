function fto = barycentric(xfr, ffr, xto)
    % Input arguments
    %
    %  xfr:  x values to fit (length n vector)
    %  ffr:  y values to fit (length n vector)
    %  xto:  x values at which to evaluate fit (length nto vector)
    %
    % Output argument
    %
    %  fto:  Interpolated values (length nto vector)
    
    n =length(xfr)-1;
    xj = ones(n+1,1)*xfr;
    xk = xfr.'*ones(1,n+1)+eye(n+1);
    w =1./prod(xj-xk,1);
    numer = xto.'*ones(1,n+1)-ones(length(xto),1)*xfr;
    [r,c] = find(numer==0);
    fto(r) = ffr(c);
    local = sum(numer==0,2);
    r2 = find(local==0);
    fto(r2) = (w.*ffr*(1./numer(r2,:)).')./(w*(1./numer(r2,:)).');
end

