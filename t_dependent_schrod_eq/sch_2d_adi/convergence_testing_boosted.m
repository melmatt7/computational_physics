clf;clear;

idpar = [0.50 0.50 0.075 0.075 0.0 0.0];
tmax = 0.01;
lambda = 0.01;
lmin = 6;
lmax = 9;
idtype = 1;
vtype = 0;
vpar = 0;

for level = lmin:lmax
    [x, y, t, psi, psire, psiim, psimod, v] = sch_2d_adi(tmax, level, lambda, idtype, idpar, vtype, vpar);
    
    if level == lmin
        tmin = t;
        xmin = x;
        ymin = y;
    else
        psi = psi(1:2^(level-lmin):end, 1:2^(level-lmin):end, 1:2^(level-lmin):end);
    end

    psil(:,:,:,(level-lmin)+1) = psi;
end

figure(1);
hold all;
for psi_index = 1:(lmax-lmin)
    dpsil = psil(:,:,:,psi_index+1)-psil(:,:,:,psi_index);    
       
    for t = 1:size(tmin,2)
        dpsil_mag(t) = rms(rms(permute(dpsil(t,:,:),[2,3,1]),2));
    end
   
    dpsil_mag = (4^(psi_index-1))*dpsil_mag;
    
    fig1(psi_index) = plot(tmin, dpsil_mag, 'color', [rand,rand,rand], 'DisplayName',  strcat('4^',int2str(psi_index-1),' level',int2str(psi_index+6),'-',int2str(psi_index+5)));
    xlabel('t'),ylabel('l-2 norm')
    title("Scaled 3 Level Convergence for Boosted Gaussian Family (2D TDSE")   
end 
legend(fig1);
hold off;