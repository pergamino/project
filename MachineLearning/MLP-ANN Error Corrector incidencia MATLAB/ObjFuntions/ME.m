function  [ObjFun] = ME(Qobs,Qsim)
a = sum((Qsim - Qobs));
ObjFun = a/length(Qobs);
end