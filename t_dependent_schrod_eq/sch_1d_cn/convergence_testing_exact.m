clf;clear;

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

    for t = 1:size(tmin,2)
        dpsil_mag(t) = rms(dpsil(t,:));
    end
    
    dpsil_mag = (4^(psi_index-1))*dpsil_mag;
    
    fig1(psi_index) = plot(tmin, dpsil_mag, 'color', [rand,rand,rand], 'DisplayName',  strcat('4^',int2str(psi_index-1),' level',int2str(psi_index+6),'-',int2str(psi_index+5)));
    xlabel('t'),ylabel('l-2 norm')
    title("Scaled 3 Level Convergence for Exact Family")   
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
    
    for t = 1:size(tmin,2)
        err_mag(t) = rms(err(t,:));
    end
    
    err_mag = (4^(err_index-1))*err_mag;
    
    fig2(err_index) = plot(tmin, err_mag, 'color', [rand,rand,rand], 'DisplayName',  strcat('4^',int2str(err_index-1),' exact - level',int2str(err_index+5)));
    xlabel('t'),ylabel('l-2 norm')
    title("Scaled 4 Level Error for Exact Family")   
end 
legend(fig2);
hold off;


