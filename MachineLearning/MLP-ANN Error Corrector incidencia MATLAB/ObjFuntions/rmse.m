function [Obj] = rmse(Qobs,Qsim)
a = (Qobs - Qsim).^2;
b = sum(a);
Obj = sqrt(b/length(Qobs));
end

