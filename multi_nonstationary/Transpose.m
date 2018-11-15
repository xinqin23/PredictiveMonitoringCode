function B_new=Transpose(B,n)
[r,c]=size(B);
B_new=zeros(r,c);
r=r/n;
c=c/n;
for i=1:r
    for j=1:c
        B_new(n*i-n+1:n*i,n*j-n+1:n*j)=B(n*i-n+1:n*i,n*j-n+1:n*j)';
    end
end