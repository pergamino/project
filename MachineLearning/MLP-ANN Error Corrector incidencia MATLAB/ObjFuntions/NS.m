function [ObjFun] = NS(Qobs,Qsim)

aa = (Qsim - Qobs).^2;
a = sum(aa);
bb = (Qobs - mean(Qobs)).^2;
b = sum(bb);

ObjFun = 1-a/b;

end