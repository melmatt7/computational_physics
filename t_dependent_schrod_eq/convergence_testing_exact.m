clf

idtype = 0;
vtype = 0;
idpar = [3];
vpar = 0;
tmax = 0.25;
lambda = 0.1;
lmin = 6;
lmax= 9;

for level = lmin:lmax
    [x, t, psi, psire, psiim, psimod, prob, v] = sch_1d_cn(tmax, level, lambda, idtype, idpar, vtype, vpar);
    
    psi = psi(1:2^(level-lmin):end, 1:2^(level-lmin):end);
    if level == lmin
        tmin = t;
        xmin = x;
    end
   
    psil(:,:,(level-lmin)+1) = psi;
end 

figure(1);
hold all;
for psi_index = 1:(lmax-lmin)
    dpsil = psil(:,:,psi_index+1)-psil(:,:,psi_index);
    dpsil(90,50)
    
    size(tmin,2);
    
    for t = 1:size(tmin,2)
        sum = 0;
        for x = 1:size(xmin,2)
            sum = sum + abs(dpsil(t,x))^2;
        end
        dpsil_mag(t) = sqrt(sum/size(xmin,2));
    end
    
    dpsil_mag = (4^(psi_index-1))*dpsil_mag;
    
    fig1(psi_index) = plot(tmin, dpsil_mag, 'color', [rand,rand,rand], 'DisplayName',  int2str(psi_index));
    %xlabel('Time [s]'),ylabel('X Displacement [m]')
    %title("Displacement of Single Mass in Two Body System")   
end 
legend(fig1);
hold off;

for t = 1:size(tmin,2)
    for x = 1:size(xmin,2)
        yexact(t,x) = exp(-1i*idpar(1)^2*pi^2*tmin(t))*sin(idpar(1)*pi*xmin(x));
    end
end

figure(2);
hold all;
for err_index = 1:(lmax-lmin)+1
    err = yexact(:,:)-psil(:,:,err_index);
    err(90,50)
    
    size(tmin,2);
    
    for t = 1:size(tmin,2)
        sum = 0;
        for x = 1:size(xmin,2)
            sum = sum + abs(err(t,x))^2;
        end
        err_mag(t) = sqrt(sum/size(xmin,2));
    end
    
    err_mag = (4^(err_index-1))*err_mag;
    
    fig2(err_index) = plot(tmin, err_mag, 'color', [rand,rand,rand], 'DisplayName',  int2str(err_index));
    %xlabel('Time [s]'),ylabel('X Displacement [m]')
    %title("Displacement of Single Mass in Two Body System")   
end 
legend(fig2);
hold off;


