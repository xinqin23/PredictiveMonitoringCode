function Sigma_ErrX_nonstationary = uni_nonstationary(p,d,q,phi,theta,T,h)

% N=1000;%%%%N must be large enouge to get converge C%%%%%%%%%%%%
% T=90;
% tt=900; % for innovation 
% h=10;
% p=2;q=1;d=2;
% phi=[1 -1 1/4]; % q + 1
% theta=[1 1]; % p + 1
sigma=1; %sigma of white noise, which stays at 1
m=max(p,q);
D=zeros(1,d+1);
N = T + h;
for i=1:d+1
    D(i)=(-1)^(i-1)*nchoosek(d,i-1);
end
[gamma,gammaXX,CX]=getgamma(N,p,q,phi,theta,sigma);
[gammaY,gammaYY,CY]=getgamma(N,0,q,[1],theta,sigma);
%%%%%%%%%%%%%%%%%%%%%%%%classic%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
GammaY=zeros(T-p,T-p);
for i=1:T-p
    for j=1:T-p
        GammaY(i,j)=gammaY(N-abs(i-j));
    end
end
C_3=zeros(h,T-p);%%%%%%%%%%%%%%%%C_3 in equation 12%%%%%%%%%%%%%%%%%
for i=1:h
    C_3(i,:)=(inv(GammaY)*flipud(gammaY(N-i-T+p+1:N-i)))';
end
[RowCY,ColumnCY]=size(CY);
C_1=CY(RowCY-h+1:RowCY,ColumnCY-q-h+1:ColumnCY);
C_2=CY(RowCY-T+p+1:RowCY,ColumnCY-T+p-q+1:ColumnCY);
C_1new=[zeros(h,T-p) C_1];
C_2new=[C_2 zeros(T-p,h)];
C_ZtoErrY=C_3*C_2new-C_1new;
Sigma_ErrY=sigma*C_ZtoErrY*eye(T+h-p+q,T+h-p+q)*C_ZtoErrY';
C_ErrYtoErrX=eye(h,h);
for i=2:h
    if i>p
        C_ErrYtoErrX(i,1)=-phi(2:p+1)*[flipud(C_ErrYtoErrX(i-p:i-1,1))];
    else
        C_ErrYtoErrX(i,1)=-phi(2:i)*[flipud(C_ErrYtoErrX(1:i-1,1))];
    end
end
for i=2:h
    for j=2:h
        if i>j
            C_ErrYtoErrX(i,j)=C_ErrYtoErrX(i-j+1,1);
        end
    end
end
Sigma_ErrX=C_ErrYtoErrX*Sigma_ErrY*C_ErrYtoErrX';
C_ErrnablaXtoErrX=eye(h,h);
for i=2:h
    if i>d
        C_ErrnablaXtoErrX(i,1)=-D(2:d+1)*[flipud(C_ErrnablaXtoErrX(i-d:i-1,1))];
    else
        C_ErrnablaXtoErrX(i,1)=-D(2:i)*[flipud(C_ErrnablaXtoErrX(1:i-1,1))];
    end
end
for i=2:h
    for j=2:h
        if i>j
            C_ErrnablaXtoErrX(i,j)=C_ErrnablaXtoErrX(i-j+1,1);
        end
    end
end
Sigma_ErrX_nonstationary = C_ErrnablaXtoErrX*Sigma_ErrX*C_ErrnablaXtoErrX';
end