function Sigma_ErrX_nonstationary = multi_nonstationary(p,d,q,phi,theta,T,h,n)
N=1000;%%%%N must be large enouge to get converge C%%%%%%%%%%%%
% N = T + h;
% T=90;
% n=2;
% tt=900; % no need for not innovation algo
% h=10;
% p=2;q=1;d=2;
sigma=1;
% phi=[1*eye(n,n) -1*eye(n,n) 1/4*eye(n,n)];
% theta=[1*eye(n,n) 1*eye(n,n)];
m=max(p,q);
D=zeros(n,n*(d+1));
for i=1:d+1
    D(:,i*n-n+1:i*n)=(-1)^(i-1)*nchoosek(d,i-1)*eye(n,n);
end
[gamma,gammaXX,CX]=multigetgamma(n,N,p,q,phi,theta,sigma);
[gammaY,gammaYY,CY]=multigetgamma(n,N,0,q,[1*eye(n,n)],theta,sigma);
%%%%%%%%%%%%%%%%%%%%%%%%classic%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
GammaY=zeros(n*(T-p),n*(T-p));
for i=1:T-p
    for j=1:T-p
        if j>i
            GammaY(n*i-n+1:n*i,n*j-n+1:n*j)=gammaY(n*(N-abs(j-i))-n+1:n*(N-abs(j-i)),:)';
        else
            GammaY(n*i-n+1:n*i,n*j-n+1:n*j)=gammaY(n*(N-abs(j-i))-n+1:n*(N-abs(j-i)),:);
        end
    end
end
%%%%%%%%%%%%%%%special property of multivariate stationary process%%%%%%%
%%%%%%%%%%%%%%cite p245 of <introduction to time series and forecast>%%
C_3=zeros(n*h,n*(T-p));%%%%%%%%%%%%%%%%C_3 in equation 12%%%%%%%%%%%%%%%%%
for i=1:h
    C_3(n*i-n+1:n*i,:)=Transpose((GammaY\Flipud(gammaY(n*(N-i-T+p)-n+1:n*(N-i-1),:),n))',n);
end
[RowCY,ColumnCY]=size(CY);
C_1=CY(RowCY-n*h+1:RowCY,ColumnCY-n*(q+h)+1:ColumnCY);
C_2=CY(RowCY-n*(T-p)+1:RowCY,ColumnCY-n*(T-p+q)+1:ColumnCY);
C_1new=[zeros(n*h,n*(T-p)) C_1];
C_2new=[C_2 zeros(n*(T-p),n*h)];
C_ZtoErrY=C_3*C_2new-C_1new;
Sigma_ErrY=sigma*C_ZtoErrY*eye(n*(T+h-p+q),n*(T+h-p+q))*C_ZtoErrY';
C_ErrYtoErrX=eye(n*h,n*h);
for i=2:h
    if i>p
        C_ErrYtoErrX(n*i-n+1:n*i,1:n)=-phi(:,n+1:n*(p+1))*Flipud(C_ErrYtoErrX(n*(i-p)-n+1:n*(i-1),1:n),n);
    else
        C_ErrYtoErrX(n*i-n+1:n*i,1:n)=-phi(:,n+1:n*i)*Flipud(C_ErrYtoErrX(1:n*(i-1),1:n),n);
    end
end
for i=2:h
    for j=2:h
        if i>j
            C_ErrYtoErrX(n*i-n+1:n*i,n*j-n+1:n*j)=C_ErrYtoErrX(n*(i-j+1)-n+1:n*(i-j+1),1:n);
        end
    end
end
Sigma_ErrX=C_ErrYtoErrX*Sigma_ErrY*C_ErrYtoErrX';
C_ErrnablaXtoErrX=eye(n*h,n*h);
for i=2:h
    if i>d
        C_ErrnablaXtoErrX(n*i-n+1:n*i,1:n)=-D(:,n+1:n*(d+1))*Flipud(C_ErrnablaXtoErrX(n*(i-d)-n+1:n*(i-1),1:n),n);
    else
        C_ErrnablaXtoErrX(n*i-n+1:n*i,1:n)=-D(:,n+1:n*i)*Flipud(C_ErrnablaXtoErrX(1:n*(i-1),1:n),n);
    end
end
for i=2:h
    for j=2:h
        if i>j
            C_ErrnablaXtoErrX(n*i-n+1:n*i,n*j-n+1:n*j)=C_ErrnablaXtoErrX(n*(i-j+1)-n+1:n*(i-j+1),1:n);
        end
    end
end
C_ZtoErrY
% Sigma_ErrY
% C_ErrYtoErrX
% Sigma_ErrX
% C_ErrnablaXtoErrX
Sigma_ErrX_nonstationary=C_ErrnablaXtoErrX*Sigma_ErrX*C_ErrnablaXtoErrX';