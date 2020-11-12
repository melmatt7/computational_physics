function [a] = nbodyaccn(m, r)
    % m: Vector of length N containing the particle masses
    % r: N x 3 array containing the particle positions
    % a: N x 3 array containing the computed particle accelerations
    
    particle_num = length(m);
    a = zeros(particle_num, 3);
    
    for i = (1:particle_num)
        for j = (1:particle_num)
            if i == j
                continue
            end
            deltar = r(j,:) - r(i,:);
            a(i,:) = a(i,:) + (m(j)/norm(deltar)^3)*deltar;
        end
    end
            
end

