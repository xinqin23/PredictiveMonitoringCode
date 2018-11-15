function [errorsCov, predictedSignal] = GetModelandErrorCov(h)
close all;
step = 0.1;
Tplot = 2;
t = 0.1:0.1:2;
y = sin(2*pi*t);
signal = y';


BG = ReadUserData();
signal = [BG];

T = length(signal);
% h = 3;
p = 3; d=1; q = 2; %over differencing is not good

Mdl = arima(p,d,q)
% Mdl = arima('Constant',0,'D',d,'Seasonality',10,...
%     'MALags',q,'SMALags',2,'ARLags',p)
[EstMdl,EstParamCov,logL,info] = estimate(Mdl,signal) %signal should be column vector
[yF, yMSE] = forecast(EstMdl,h,'Y0',signal)


Mdl = arima(p,d,q)
% Mdl = arima('Constant',0,'D',d,'Seasonality',10,...
%     'MALags',q,'SMALags',2,'ARLags',p)
[EstMdl,EstParamCov,logL,info] = estimate(Mdl,signal) %signal should be column vector
[yF, yMSE] = forecast(EstMdl,h,'Y0',signal)




figure
plot(t,signal,'Color',[.5,.5,.5])
hold on
h1 = plot(Tplot+1*step:step:Tplot+h*step,yF,'r','LineWidth',2);

%step is 0.1 so


% p =EstMdl.P
% d = EstMdl.D
% q = EstMdl.Q

varNumber = 1;
phi = [eye(varNumber) cell2mat(EstMdl.AR)]
theta = [eye(varNumber) cell2mat(EstMdl.MA)]


errorsCov = uni_nonstationary(p,d,q,phi,theta,T,h);



% identity  = ones(varNumber,h);
% chigh = identity*0;
% clow = identity*-9999;
% mu = zeros(1,h);
% predictedSignal = yF'
% [low, up] = CalIntervals(clow, chigh,predictedSignal)
% guarantee1 = mvncdf(low,up,mu,errorsCov) %positive definate
% 1- guarantee1

% identity  = ones(1,h);
% clow = identity*0;
% chigh = identity*9999;
% mu = zeros(1,h);
predictedSignal = yF';
% [low, up] = CalIntervals(clow, chigh,predictedSignal)
% guarantee2 = mvncdf(low,up,mu,errorsCov)

end