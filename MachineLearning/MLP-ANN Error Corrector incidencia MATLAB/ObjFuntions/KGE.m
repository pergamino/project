function [obj] = KGE(Qobs,Qsim)
% Correlation Coefficient 
r = corr2(Qobs,Qsim); 
% the ratio between the simulated and observed variance
alpha = std(Qsim)/std(Qobs); 
% the ratio between the simulated and observed mean
beta = mean(Qsim)/mean(Qobs);
% Computation of the Kling-Gupta Efficiency
obj = 1 - sqrt(power((r - 1),2) + power((alpha - 1),2) + power((beta - 1),2));
end

