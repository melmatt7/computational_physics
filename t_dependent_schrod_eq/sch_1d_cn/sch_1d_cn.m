function [x, t, psi, psire, psiim, psimod, prob, v] = sch_1d_cn(tmax, level, lambda, idtype, idpar, vtype, vpar)
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
    % t: Vector of t coordinates [nt]
    % psi: Array of computed psi values [nt x nx]
    % psire Array of computed psi_re values [nt x nx]
    % psiim Array of computed psi_im values [nt x nx]
    % psimod Array of computed sqrt(psi psi*) values [nt x nx]
    % prob Array of computed running integral values [nt x nx]
    % v Array of potential values [nx]
    
    % discretization
    nx = 2^level + 1;
    deltax = 2^(-level);
    deltat = lambda*deltax;
    nt = round(tmax/deltat)+1;
    
    t = [0 : nt-1] * deltat;
    x = linspace(0.0, 1.0, nx);
    
    psi = zeros(nt,nx);
    switch idtype
        case 0
            m = idpar(1);
            psi(1,:) = sin(m*pi*x);
        case 1
            x0 = idpar(1);
            gamma = idpar(2);
            p = idpar(3);
            psi(1,:) = exp(1i*p.*x).*exp(-((x-x0)/gamma).^2);
    end
    
    switch vtype
        case 0
            v = zeros(nx,1);
        case 1
            xmin = vpar(1);
            xmax = vpar(2);
            Vc = vpar(3);
            
            v = zeros(nx,1);
            
            XminIndex = find(x>=xmin, 1);
            XmaxIndex = find(x>=xmax, 1);
            v(XminIndex:XmaxIndex) = Vc;
    end
    
    f = zeros(nx,1);
    d1 = zeros(nx,1);
    d2 = zeros(nx,1);
    o = ones(nx,1);
    ratio = (deltat/deltax^2)*o;
    alphal = (1i/2)*ratio;
    alphau = alphal;
    d1  = o + 1i*ratio + 1i*deltat*v/2;
    d2 = o - 1i*ratio - 1i*deltat*v/2;
    
    d1(1) = 1.0;
    d1(nx) = 1.0;
    d2(1) = 1.0;
    d2(nx) = 1.0;
    
    alphau(2) = 0.0;
    alphal(nx-1) = 0.0;    
    
    u1 = spdiags([-alphal, d1, -alphau], -1:1, nx, nx);
    %full(u1);
    u2 = spdiags([alphal, d2, alphau], -1:1, nx, nx);
    
    for n = 1:nt-1
        f = u2*psi(n,:).';
        f(1) = 0;
        f(nx) = 0;
        
        psi(n+1, :) = u1\f;
    end
    
    psire = real(psi);
    psiim = imag(psi);
    
    ro = psi.*conj(psi);
    psimod = sqrt(ro);
%     x(1,1:4)
%     ro(1:8,1:4)
    prob = cumtrapz(x, ro, 2);
%     prob(1:8,1:4)
end

