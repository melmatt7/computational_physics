function [x, y, t, psi, psire, psiim, psimod, v] = sch_2d_adi(tmax, level, lambda, idtype, idpar, vtype, vpar)
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
    
    rx = (1i*deltat)/(2*deltax^2);
    ry = (1i*deltat)/(2*deltay^2);
    
    psi = zeros(nt,nx,ny);
    
    switch idtype
        case 0
            mx = idpar(1);
            my = idpar(2);
            
            psi(1,:,:) = sin(mx*pi*x).*sin(my*pi*y).';      
        case 1
            x0 = idpar(1);
            y0 = idpar(2);
            gammax = idpar(3);
            gammay = idpar(4);
            px = idpar(5);
            py = idpar(6);
            
            psi(1,:,:) = exp(1i*px.*x-((x-x0)./gammax).^2).*exp(1i*py.*y-((y-y0)./gammay).^2).';           
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

            XminIndex = find(x>=xmin, 1);
            XmaxIndex = find(x>=xmax, 1);            
            YminIndex = find(y>=ymin, 1);
            YmaxIndex = find(y>=ymax, 1);
                        
            v = zeros(nx,ny);
            v(XminIndex:XmaxIndex,YminIndex:YmaxIndex) = Vc;                        
        case 2
            x1 = vpar(1);
            x2 = vpar(2);
            x3 = vpar(3);
            x4 = vpar(4);
            Vc = vpar(5);
            
            v = zeros(nx,ny);
            jprime = (ny-1)/4 + 1;
            v(:,jprime) = Vc;
            v(:,jprime+1) = Vc;
            
            X1Index = find(x>=x1, 1);
            X2Index = find(x>=x2, 1);            
            X3Index = find(y>=x3, 1);
            X4Index = find(y>=x4, 1);
            
            v(X1Index:X2Index,:) = 0;
            v(X3Index:X4Index,:) = 0;           
    end

    ox = ones(nx-2,1);
    dl = [-rx*ox; 0; 0];
    d  = [1; (1+2*rx)*ox; 1];
    du = [0; 0; -rx*ox;];   
    lhs1 =  spdiags([dl,d,du], [-1,0,1], nx, ny);
    
    oy = ones(ny-2,1);
    dl = [-ry*oy;0;0];
    du = [0;0;-ry*oy];  
    
    for n = 1:nt-1
        curr_psi = permute(psi(n, :, :), [2,3,1]);
        half_psi = zeros(size(curr_psi,1), size(curr_psi,2));
        new_psi = zeros(size(curr_psi,1), size(curr_psi,2));
        
        % intermediate time step
        rhs1 = zeros(nx,1);
        first_op = zeros(nx,1);
        xx = zeros(nx,1);
        for j = 2:ny-1
           yy = curr_psi(:,j+1) ...
              - 2*curr_psi(:,j) ...
              + curr_psi(:,j-1);
            
           first_op(2:nx-1) = curr_psi(2:nx-1,j) ...
                            + ry*yy(2:nx-1) ...
                            - (ry*deltax^2)*v(2:nx-1,j).*curr_psi(2:nx-1,j);       
           for i = 2:nx-1
               xx(i) = first_op(i-1) ...
                     - 2*first_op(i) ...
                     + first_op(i+1);        
           end
                               
           rhs1(2:nx-1) = first_op(2:nx-1) ...
                        + rx*xx(2:nx-1); 
                        
            rhs1(1) = 0;
            rhs1(ny) = 0;
            half_psi(:,j) = lhs1\rhs1;
        end
        
        
        % complete time step
        rhs2 = zeros(ny,1);
        for i = 2:nx-1           
            rhs2(2:ny-1) = half_psi(i, 2:ny-1); 
            
            d  = [1;(1+2*ry+ry*deltay^2*v(i,2:ny-1).').*oy;1];
              
            lhs2 =  spdiags([dl,d,du], [-1,0,1], nx, ny);
    
            rhs2(1) = 0;
            rhs2(ny) = 0;
            
            new_psi(i,:) = lhs2\rhs2;
        end
    
        psi(n+1, :, :) = new_psi;
    end

    psire = real(psi);
    psiim = imag(psi);
    ro = psi.*conj(psi);
    psimod = sqrt(ro);
end
    
