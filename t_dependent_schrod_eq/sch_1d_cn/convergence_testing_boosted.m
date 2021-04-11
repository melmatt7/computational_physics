clf;clear;

idtype = 1;
vtype = 0;
idpar = [0.50 0.075 0.0];
vpar = 0;
tmax = 0.01;
lambda = 0.01;
lmin= 6;
lmax= 9;

for level = lmin:lmax
    [x, t, psi, psire, psiim, psimod, prob, v] = sch_1d_cn(tmax, level, lambda, idtype, idpar, vtype, vpar);
    
    size(psi);
    psi = psi(1:2^(level-lmin):end, 1:2^(level-lmin):end);
    size(psi);
    
    if level == lmin
        tmin = t;
        xmin = x;
    end
   
    size(tmin);
    psil(:,:,(level-lmin)+1) = psi;
end 

size(tmin);
figure(1);
hold all;
for psi_index = 1:(lmax-lmin)
    dpsil = psil(:,:,psi_index+1)-psil(:,:,psi_index);
    
    size(tmin);

    for t = 1:size(tmin,2)
        dpsil_mag(t) = rms(dpsil(t,:));
    end
    
    dpsil_mag = (4^(psi_index-1))*dpsil_mag;
    
    fig1(psi_index) = plot(tmin, dpsil_mag, 'color', [rand,rand,rand], 'DisplayName',  strcat('4^',int2str(psi_index-1),' level',int2str(psi_index+6),'-',int2str(psi_index+5)));
    xlabel('t'),ylabel('l-2 norm')
    title("Scaled 3 Level Convergence for Boosted Gaussian Family")   
end 
legend(fig1);
hold off;