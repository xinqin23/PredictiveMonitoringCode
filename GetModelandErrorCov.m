function [errorsCov, predictedSignal] = GetModelandErrorCov(h)
close all;
% step = 0.1;
% t = 0.1:0.1:2;
% y = sin(2*pi*t);
% signal = y';
% h = 5

 
datafile = './GenedData/BGTrace1.txt'
BG = ReadUserData(datafile);
total = length(BG)
signal = [BG(1:total*4/5)];
% 
% % autocorr(BG) % check autocorr
% parcorr(BG)

% 
% randn('seed',1);
% whitenoise = randn(1,50);
% signal = whitenoise';


T = length(signal)
% step = 15
t = 1:T; 

% h = 3;
p = 3; d=2; q = 1; %over differencing is not good
% p = 0; d= 0; q = 0; %check uni 1 correct

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


groundt = 1:total;

figure
plot(signal)
hold on
h1 = plot(T+1:T+h,yF,'r','LineWidth',2);
hold on
h2 = plot(groundt,BG,'Color',[.5,.5,.5])
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