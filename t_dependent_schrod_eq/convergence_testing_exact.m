clf;clear;

idpar = [2, 3];
tmax = 0.05;
lambda = 0.05;
lmin = 6;
lmax = 8;
idtype = 0;
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

size(tmin,2)
for t = 1:size(tmin,2)
    yexact(t,:,:) = exp(-1i*(idpar(1)^2+idpar(2)^2)*pi^2*tmin(t)).*sin(idpar(1)*pi*xmin).*sin(idpar(2)*pi*ymin).';
end

figure(2);
hold all;
for err_index = 1:(lmax-lmin)+1
    err = yexact(:,:,:)-psil(:,:,:,err_index);
    
    for t = 1:size(tmin,2)    
        err_mag(t) = rms(rms(permute(err(t,:,:), [2,3,1]),2));
    end
    
    err_mag = (4^(err_index-1))*err_mag;
    
    fig2(err_index) = plot(tmin, err_mag, 'color', [rand,rand,rand], 'DisplayName',  int2str(err_index));
    %xlabel('Time [s]'),ylabel('X Displacement [m]')
    %title("Displacement of Single Mass in Two Body System")   
end 
legend(fig2);
hold off;
