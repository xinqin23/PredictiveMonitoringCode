function B_new=Flipud(B,n)
l=length(B);
d=l/n;
for i=1:d
    Temp(i).B=B(n*(i-1)+1:n*i,1:n);
end
for i=1:d
    B_new(n*(i-1)+1:n*i,1:n)=Temp(d-i+1).B;
end
end