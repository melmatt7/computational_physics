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

            XminIndex = find(x>=xmin);
            XmaxIndex = find(x>=xmax);            
            YminIndex = find(y>=ymin);
            YmaxIndex = find(y>=ymax);
                        
            v = zeros(nx,ny);
            v(XminIndex:XmaxIndex,YminIndex:YmaxIndex) = Vc;
            
    end
    
    
    
    
%     Lx = ox;
%     Dx = 
%     Ux = 
%     Mx = 
%     
%     Ly = 
%     Dy = 
%     Uy =
%     My = 
%     
%     trix = spdiags([ox, -2*ox, ox],[-1,0,1], nx-2, nx-2);
%     Uxpos = speye(nx-2) + ratio*trix;
%     Uxneg = speye(nx-2) - ratio*trix;
%     
%     triy = spdiags([oy, -2*oy, oy],[-1,0,1], ny-2, ny-2);
%     Uypos = speye(nx-2) + ratio*triy;
%     Uyneg = speye(nx-2) - ratio*triy;
%     
%        
%     tri = spdiags([-ones(nx-1,1), 2*ones(nx-1,1), -ones(nx-1,1)],[-1,0,1], nx-1, nx-1);
%     A = speye(nx-1) + ratio*tri;
%     
%     fpos = zeros(nx,nx);
%     fneg = zeros(nx,nx);
%     inter_vals = zeros(nx-1,ny-1);
    ox = ones(nx-2,1);
    dl = [-rx*ox; 0; 0];
    d  = [1; (1+2*rx)*ox; 1];
    du = [0; 0; -rx*ox;];   
    lhs1 =  spdiags([dl,d,du], [-1,0,1], nx, ny);
    
    
    
    for n = 1:nt-1
        curr_psi = permute(psi(n, :, :), [2,3,1]);
        half_psi = zeros(size(curr_psi,1), size(curr_psi,2));
        new_psi = zeros(size(curr_psi,1), size(curr_psi,2));
        
        
        % x-sweep to determine intermediate time step
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
                    
%             size(b1)
%             for k = 2:nx-1
%                 for p = 2:ny-1
%                     b(i,j) = b1(k, p) + ratio*(b1(k-1,p) - 2*b1(k,p) + b1(k+1,p));
%                 end
%             end
                        
            rhs1(1) = 0;
            rhs1(ny) = 0;
            half_psi(:,j) = lhs1\rhs1;
        end
        
        
        % y-sweep to detemine complete time step
        rhs2 = zeros(ny,1);
        for i = 2:nx-1           
            rhs2(2:ny-1) = half_psi(i, 2:ny-1); 
            
            oy = ones(ny-2,1);
    
            dl = [-ry*oy;0;0];
            d  = [1;(1+2*ry+ry*deltay^2*v(i,2:ny-1).').*oy;1];
            du = [0;0;-ry*oy];    
            lhs2 =  spdiags([dl,d,du], [-1,0,1], nx, ny);
    
            rhs2(1) = 0;
            rhs2(ny) = 0;
            
            new_psi(i,:) = (lhs2\rhs2);
        end

%         % boundary conditions
%         for k = 1:nx
%             new_psi(1,k) = 0;
%             new_psi(nx,k) = 0;
%             new_psi(k,1) = 0;
%             new_psi(k,ny) = 0;
%         end
%         
        psi(n+1, :, :) = new_psi;
    end

    psire = real(psi);
    psiim = imag(psi);
    ro = psi.*conj(psi);
    psimod = sqrt(ro);
end
    
