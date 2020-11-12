function [a] = nbodyaccn_total(m, num_m0, r)
    % m: Vector of length N containing the particle masses
    % num_m0: number of massless particles M
    % r: N x (M+1) x 3 array containing the particle positions
    % a: N x (M+1) x 3 array containing the computed particle accelerations
       
    particle_num = length(m);
    massless_particle_num = num_m0;
    a = zeros(particle_num, massless_particle_num+1, 3);
    
    for i = (1:particle_num)
        for k = (1:massless_particle_num+1)
            for j = (1:particle_num)
                % Skip calculating interactions between the same core
                if i == j && k == 1
                    continue
                end
                
                % Relevant core position minus every star position
                deltar = reshape(r(j,1,:) - r(i,k,:),[1,3]);
                a(i,k,:) = reshape(a(i,k,:),[1,3]) + (m(j)/norm(deltar)^3)*deltar;
            end
        end
    end
            
end


