function genMultiVar(varNumber)

t = 0:0.1:3*pi;
y = sin(t);
z = cos(2*t);

h = 10;
p = 3; q = 0; d = 1;%over differencing is not good



% points = 0:d:3*pi;
% dy = interp1(t,y,points)
% dz = interp1(t,z,points)
% signal = [dy' dz']

signal = [y' z']

T = length(signal);

varNumber = 2;
Mdl = varm(varNumber,p)
% Mdl = arima('Constant',0,'D',d,'Seasonality',10,...
%     'MALags',q,'SMALags',2,'ARLags',p)
[EstMdl,EstParamCov] = estimate(Mdl,signal) %signal should be column vector
[yF, yMSE] = forecast(EstMdl,h,signal)




figure
plot(signal,'Color',[.5,.5,.5])
hold on
h1 = plot(T+1:T+h,yF,'r','LineWidth',2);



p =EstMdl.P
% d = EstMdl.D
% q = EstMdl.Q

% n = 2;
% phi=[1*eye(n,n) -1*eye(n,n) 1/4*eye(n,n)];
phi = [eye(varNumber)  cell2mat(EstMdl.AR)]
% p = 2; q = 1; d= 2;
% phi=[1*eye(n,n) -1*eye(n,n) 1/4*eye(n,n)];
% theta=[1*eye(n,n) 1*eye(n,n)];
theta = eye(varNumber)


% === multi variate
errorsCov = multi_nonstationary(p,d,q,phi,theta,T,h,varNumber)

identity  = ones(1,h*varNumber);
chigh = identity*9999;
clow = identity*-9999;
mu = zeros(1,h*varNumber);
predictedSignal = [yF(:,1)' yF(:,2)']
[low, up] = CalIntervals(clow, chigh,predictedSignal)
guarantee1 = mvncdf(low,up,mu,errorsCov) %positive definate
1- guarantee1

% identity  = ones(1,h);
% clow = identity*0;
% chigh = identity*9999;
% mu = zeros(1,h);
% predictedSignal = yF'
% [low, up] = CalIntervals(clow, chigh,predictedSignal)
% guarantee2 = mvncdf(low,up,mu,errorsCov)

end

