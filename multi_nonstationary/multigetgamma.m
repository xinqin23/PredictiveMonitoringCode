function [gamma,gammaXX,C]=multigetgamma(n,N,p,q,phi,theta,sigma)
Phi=zeros(n*(N-p),n*N);
for i=1:n:n*(N-p)
    Phi(i:i+n-1,i:n*((i-1)/n+1+p))=Fliplr(phi,n);
end
Theta=zeros(n*(N-p),n*N);
for i=1:n:n*(N-p)
    Theta(i:i+n-1,i:n*((i-1)/n+1+q))=Fliplr(theta,n);
end
C=pinv(Phi)*Theta;
Sigma=sigma*eye(n*(N-min(0,p-q)),n*(N-min(0,p-q)));%%%%%%%%%%%%%%%%%%%%%%%%sigma=sigma_z%%%%%%%%%%%%%%%%%%%%
S=C*Sigma*C';
gamma=zeros(n*N,1);
gamma=S(n*(N-1)+1:n*N,:)';%%%%%%%%%%%%gamma(T-i)=gamma_X(i)%%%%%%%%%%%%%%%%
gammaX=Flipud(gamma,n);
gammaXX=[Flipud(gammaX(n+1:n*N,:),n);gammaX];
end