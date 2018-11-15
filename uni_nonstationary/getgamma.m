function [gamma,gammaXX,C]=getgamma(N,p,q,phi,theta,sigma)
Phi=zeros(N-p,N);
for i=1:N-p
    Phi(i,i:i+p)=fliplr(phi);
end
Theta=zeros(N-p,N);
for i=1:N-p
    Theta(i,i:i+q)=fliplr(theta);
end
C=pinv(Phi)*Theta;
Sigma=sigma*eye(N-min(0,p-q),N-min(0,p-q));%%%%%%%%%%%%%%%%%%%%%%%%sigma=sigma_z%%%%%%%%%%%%%%%%%%%%
S=C*Sigma*C';
gamma=S(N,:)';%%%%%%%%%%%%gamma(T-i)=gamma_X(i)%%%%%%%%%%%%%%%%
gammaX=flipud(gamma);
gammaXX=[flipud(gammaX(2:N));gammaX];
end