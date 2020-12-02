clf;clear;

idpar = [0.50 0.50 0.075 0.075 0.0 0.0];
tmax = 0.01;
lambda = 0.01;
lmin = 5;
lmax = 8;
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

%     for tval = 1:size(tmin)
%         surf(xmin,ymin,permute(psi(tval,:,:),[2,3,1]))
%         drawnow
%     end
    size(psi)
    psil(:,:,:,(level-lmin)+1) = psi;
end

figure(1);
hold all;
for psi_index = 1:(lmax-lmin)
    dpsil = psil(:,:,:,psi_index+1)-psil(:,:,:,psi_index);    
    
%     for t = 1:size(tmin,2)
% %         sum = 0;
% %         for x = 1:size(xmin,2)
% %             for y = 1:size(ymin,2)
% %                 sum = sum + abs(dpsil(t,x,y))^2;
% %             end
% %         end
%         dpsil_mag(t) = sqrt(sum(sum((dpsil(t,:,:) .* conj(dpsil(t,:,:)))))/prod(size(dpsil(t,:,:))));
%     end
    
    for t = 1:size(tmin,2)
        dpsil_mag(t) = rms(rms(permute(dpsil(t,:,:),[2,3,1]),2));
    end
   
    dpsil_mag = (4^(psi_index-1))*dpsil_mag;
    
    fig1(psi_index) = plot(tmin, dpsil_mag, 'color', [rand,rand,rand], 'DisplayName',  int2str(psi_index));
    %xlabel('Time [s]'),ylabel('X Displacement [m]')
    %title("Displacement of Single Mass in Two Body System")   
end 
legend(fig1);
hold off;