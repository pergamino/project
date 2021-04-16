%{
Created by: Jose Valles
Function that allows to train a MLP-ANN network using logsigmoid transfer
function and a linear fucntion in the output
%}
function [Et,Ec,Ev,w,yt,yc,yv,net] = MLPfunct(HiddenNodes,Train,CrossVal,Verification)
%% The MLP model using the ANN Toolbox provided by MATLAB
net = feedforwardnet(HiddenNodes); % Define network architecture
net.trainFcn = 'trainlm'; % Training Function Levenberg-Marquardt Optimization
net.divideFcn = 'dividetrain'; % Assign all the v-data into the training set. 
net.layers{1}.transferFcn = 'logsig'; % Assign the sigmoud function to the hidden layers
net.layers{2}.transferFcn = 'purelin'; % Linear combination of the variables
net.trainParam.showWindow = 0; % Show the NNTool GUI. (1) true - (0) false
%% Separate variables
% Training
Xt = Train(:,1:end-1)'; % Training input
Yt = Train(:,end)'; % Training output/target
% Cross Validation
Xc = CrossVal(:,1:end-1)'; % Cross-Validation input
Yc = CrossVal(:,end)'; % Cross-Validation output/target
% Verification
Xv = Verification(:,1:end-1)'; % Verification input
Yv = Verification(:,end)'; % Verification output/target
%% Train the network
% rng default % Random control for avoiding different outputs
[net,~] = train(net,Xt,Yt);
%% Evaluate the trained network with the train data
yt = net(Xt);
Et(1,1) = ME(Yt,yt);
Et(1,2) = NS(Yt,yt);
Et(1,3) = rmse(Yt,yt);
Et(1,4) = Et(1,3)/std(Yt);
mdl = fitlm(Yt,yt);
Et(1,5) = mdl.Rsquared.Ordinary; clear mdl
Et(1,6) = KGE(Yt,yt);
%% Cross-Validation
yc = net(Xc);
Ec(1,1) = ME(Yc,yc);
Ec(1,2) = NS(Yc,yc);
Ec(1,3) = rmse(Yc,yc);
Ec(1,4) = Ec(1,3)/std(Yc);
mdl = fitlm(Yc,yc);
Ec(1,5) = mdl.Rsquared.Ordinary; clear mdl
Ec(1,6) = KGE(Yc,yc);
%% Verification
yv = net(Xv);
Ev(1,1) = ME(Yv,yv);
Ev(1,2) = NS(Yv,yv);
Ev(1,3) = rmse(Yv,yv);
Ev(1,4) = Ev(1,3)/std(Yv);
mdl = fitlm(Yv,yv);
Ev(1,5) = mdl.Rsquared.Ordinary; clear mdl
Ev(1,6) = KGE(Yv,yv);
% Store the weights 
w.Iw = cell2mat(net.IW);
w.b1 = cell2mat(net.b(1));
w.Lw = cell2mat(net.Lw);
w.b2 = cell2mat(net.b(2));
end