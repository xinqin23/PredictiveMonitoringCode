function B_new=Diag(B,n)
l=length(B);
d=l/n;
B_new=zeros(n*d,n*d);
for i=1:d
    Temp(i).B=B(1:n,n*(i-1)+1:n*i);
end
for i=1:n:n*d
    B_new(i:i+n-1,i:i+n-1)=Temp((i-1)/n+1).B;
end
end