function B_new=Fliplr(B,n)
l=length(B);
d=l/n;
for i=1:d
    Temp(i).B=B(1:n,n*(i-1)+1:n*i);
end
for i=1:d
    B_new(1:n,n*(i-1)+1:n*i)=Temp(d-i+1).B;
end
end