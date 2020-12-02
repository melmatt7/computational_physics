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
    %dpsil(90,50);
    
    size(tmin);
    
%     for t = 1:size(tmin,2)
%         sum = 0;
%         for x = 1:size(xmin,2)
%             sum = sum + abs(dpsil(t,x))^2;
%         end
%         dpsil_mag(t) = sqrt(sum/size(xmin,2));
%     end

    for t = 1:size(tmin,2)
        dpsil_mag(t) = rms(dpsil(t,:));
    end
    
    dpsil_mag = (4^(psi_index-1))*dpsil_mag;
    size(dpsil_mag);
    
    fig1(psi_index) = plot(tmin, dpsil_mag, 'color', [rand,rand,rand], 'DisplayName',  int2str(psi_index));
    %xlabel('Time [s]'),ylabel('X Displacement [m]')
    %title("Displacement of Single Mass in Two Body System")   
end 
legend(fig1);
hold off;