function [x y t psi psire psiim psimod v] = sch_2d_adi(tmax, level, lambda, idtype, idpar, vtype, vpar)
    % Inputs
    %
    % tmax: Maximum integration time
    % level: Discretization level
    % lambda: dt/dx
    % idtype: Selects initial data type
    % idpar: Vector of initial data parameters
    % vtype: Selects potential type
    % vpar: Vector of potential parameters
    %
    % Outputs
    %
    % x: Vector of x coordinates [nx]
    % y: Vector of y coordinates [ny]
    % t: Vector of t coordinates [nt]
    % psi: Array of computed psi values [nt x nx x ny]
    % psire Array of computed psi_re values [nt x nx x ny]
    % psiim Array of computed psi_im values [nt x nx x ny]
    % psimod Array of computed sqrt(psi psi*) values [nt x nx x ny]
    % v Array of potential values [nx x ny]
    nx = 2^level + 1;
    ny = 2^level + 1;
    deltax = 2^(-level);
    deltay = 2^(-level);
    deltat = lambda*deltax;
    nt = round(tmax/deltat)+1;
    
    t = [0 : nt-1] * deltat;
    x = linspace(0.0, 1.0, nx);
    y = linspace(0.0, 1.0, ny);
    
    psi = zeros(nx,ny,nt);
    switch idtype
        case 0
            mx = idpar(1);
            my = idpar(2);
            psi(:,:,1) = sin(mx*pi*x)*sin(my*pi*y);
        case 1
            x0 = idpar(1);
            y0 = idpar(2);
            gammax = idpar(3);
            gammay = idpar(4);
            px = idpar(5);
            py = idpar(6);
            psi(:,:,1) = exp(1i*px.*x).*exp(1i*py.*y).*exp(-((x-x0)/gammax).^2+((y-y0)/gammay).^2);
    end
    
    switch vtype
        case 0
            v = zeros(nx,ny);
        case 1
            xmin = vpar(1);
            xmax = vpar(2);
            ymin = vpar(3);
            ymax = vpar(4);
            Vc = vpar(5);
            v = zeros(nx,ny);
            v(x>=xmin,y>=ymin) = Vc;
            v(x<=xmax,y>=ymax) = Vc;
    end
    
%     r = 1i*deltat/2
end
