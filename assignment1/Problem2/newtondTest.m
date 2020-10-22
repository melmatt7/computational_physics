function newtondTest()
    h = 10^-5;
    x0 = [-1.00;0.75;1.50];
    tol = 0.00001;
    res = newtond(@f, @jacfd, h, x0, tol)
    norm(f(res))
    
    %x = optimvar('x',3); 
    %f1 = x(1)^2+x(2)^4+x(3)^6-2 == 0;
    %f2 = cos(x(1)*x(2)*x(3)^2)-x(1)-x(2)-x(3) == 0;
    %f3 = x(2)^2+x(3)^2-(x(1)+x(2)-x(3))^2 == 0;
    %prob = eqnproblem;
    %prob.Equations.eq1 = f1;
    %prob.Equations.eq2 = f2;
    %prob.Equations.eq3 = f3;
    %show(prob);
    %x1.x = [-1.00;0.75;1.50];
    %[sol,fval,exitflag] = solve(prob,x1);
    %disp(sol.x)
end

function fx = f(t)
    x = t(1);
    y = t(2);
    z = t(3);

    fx = [x.^2+y.^4+z.^6-2; cos(x*y*z.^2)-x-y-z;  y.^2+z.^3-(x+y-z).^2];
end

function jacfdx = jacfd(f, x, h)
    d = length(x);
    jacfdx = zeros(d,d);
    for i = 1:d
        jacfdx(i,:) = funcGradient(f, i, x, d, h);
    end
end

function grad = funcGradient(f, i, x, d, h)
    grad = zeros(1,d);
    
    for j = 1:d
        xshift = x;
        
        xshift(j) = xshift(j) + h;
        
        fxshift = f(xshift);
        fx = f(x);
        grad(1,j) = (fxshift(i) - fx(i))./(h);
    end 
end