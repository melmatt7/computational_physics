function hybridTest()
    %res = findIntervals(-2, 3, @p)
    res = hybrid(@g,@dfdx, 0, 5, 0.00001, 0.00001);
end

function fx = f(x)
    fx = x.^2-6;
end

function gx = g(x)
    gx = 512*x.^10-5120*x.^9+21760*x.^8-51200*x.^7+72800*x.^6-64064*x.^5+34320*x.^4-10560*x^3+1650*x^2-100*x+1;
end

function px = p(x)
    px = 3*x.^3-4*x.^2-17*x+6;
end

function dfxdx = dfdx(f,xval)
    syms x
    dfxdx = eval(subs(diff(f(x),x),x,xval));
end
