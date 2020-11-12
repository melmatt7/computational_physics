function val = costaylor(x, tol, kmax)
% costaylor Computes an approximation to cos(x) using Taylor series
%  
% Input arguments
%
%  x:     The value of x at which the approximation is to be computed.
%  tol:   The tolerance for the computation.  The function will
%         return the approximation when the magnitude of the current 
%         term being summed is <= this value.
%  kmax:  The maximum number of terms that will be summed.
%
% Output argument 
%
%  val:   The approximate value of cos(x).
%      
% Also illustrates the use of the return statement to exit a function 
% immediately (i.e. before the end of the function definition).

   % Initialize the output argument.
   val = 0;
   for k = 0 : kmax - 1
      % Compute k-th term in series.
      term =  (-1)^(k) * x^(2*k) / factorial(2*k);
      % Update the approximation.
      val = val + term;
      % If the magnitude of the current term is smaller than 
      % the tolerance, exit the procedure using the return statement.
      if abs(term) <= tol;
         return;
      end
   end
   % If execution reaches this point then convergence to the requested
   % tolerance has not been achieved using the specified maximum 
   % number of terms.  Set the output argument to NaN and return.
   val = NaN;

end