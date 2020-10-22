function dft(M, N)
%DFT Summary of this function goes here
%   Detailed explanation goes here
    I  = [206.0, 163.0, 158.0; 112.0, 153.0, 200.0];
    I = transpose(I);
    
    
    val = 0;
    
    
        for u = 0:2
            for v = 0:1
                    for x = 0:2
                        for y = 0:1
                            K = 2*pi*(u*x/M+v*y/N);
                            I(x+1,y+1);
                            val = val + I(x+1,y+1)*exp(-1i*K);
                        end
                    end
                mag = abs(val)
                phase = angle(val)
                phasea = atan(imag(val)/real(val))
                val = 0;
            end
        end
    
    
end

