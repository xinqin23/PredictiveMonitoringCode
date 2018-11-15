function B_new=Sum(B,n)
l=length(B);
d=l/n;
for i=1:d
    Temp(i).B=B(n*(i-1)+1:n*i,:);
end
B_new=zeros(n,n);
for i=1:d
    B_new=B_new+Temp(i).B;
end
end