function [p]=unit_commitment(cost,pu,pl,pd,lamda)
%cost= [500 5.3 0.004;400 5.5 0.006;200 5.8 0.009;500 4.7 0.007];
%pu=[450 350 225 400];
%pl=[200 150 100 150]; 
%pd=800;
%lamda=6;
n=length(pl);
com=2^n;
com=com-1;
for i=1:com
a=dec2bin(i);
g=log2(i);
g=fix(g);
for j=0:g
p(i+1,g+1-j)=str2num(a(1,j+1));
end
end
for t=1:(com+1)
    p(t,n+1)=0;
    p(t,n+2)=0;
end
for k=1:(com+1)
    for q=1:n
if p(k,q)==1
    p(k,n+1)=p(k,n+1)+pl(1,q);
    p(k,n+2)=p(k,n+2)+pu(1,q);
end end
end
for v=1:(com+1)
f=1;
if p(v,n+2)>=pd
    for u=1:n
        if p(v,u)==1
        e(f,1)=cost(u,1);
        e(f,2)=cost(u,2);
        e(f,3)=cost(u,3);
        pl1(1,f)=pl(1,u);
        pu1(1,f)=pu(1,u);
        f=f+1;
        end
    end
[p1,lamda1,cost1]=lamda_iteration (e,pu1,pl1,pd,lamda);
r=1;
for x=1:n
    if p(v,x)==1
        p(v,n+2+x)=p1(r,1);
        r=r+1;
    end
end
end
end
n2=length(pl);
for i2=1:n2
    a2(i2,1)=cost(i2,1);
    b2(i2,1)=cost(i2,2);
    y2(i2,1)=cost(i2,3);
end
for z=1:n
for b=1:(com+1)
    if p(b,n+2+z)>0
    p(b,2*n+2+z)=a2(z,1)+b2(z,1)*p(b,n+2+z)+y2(z,1)*p(b,n+2+z)*p(b,n+2+z);
    end 
end
end
for d=1:(com+1)
    p(d,3*n+3)=0;
    for h=1:n
    p(d,3*n+3)=p(d,2*n+2+h)+p(d,3*n+3);
    end
end
