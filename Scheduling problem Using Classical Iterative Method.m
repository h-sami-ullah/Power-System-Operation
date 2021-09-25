M=1;N=1;
% thermal unit
a=0.01;b=0.1;c=100;ptmax=50;ptmin=10;
% hydro unit
x=0.05;y=20;z=140;
phmax=200;phmin=200;v1=25000;
pd1=250;pd2=300;
% Computing the initial guess
pt1=(pd1/(M+N))
pt2=(pd2/(M+N))
ph1=(pd1/(M+N))
ph2=(pd2/(M+N))
lumbda0=2*a*pt1+b;
vj1=(lumbda0/(2*x*ph1+y))
delV=1;
iter = 0;
while abs(delV)>=0.01
v1=25000;
iter=iter+1;
f=(((b/a)+(y/x))/(2));
g=((1/a)+(1/(x*vj1)));
lumbda1=2*((pd1+f)/(g))
p11=((lumbda1-b)/(2*a))
p21=((lumbda1-(y*vj1))/(2*x*vj1))
lumbda2=2*((pd2+f)/(g))
p12=((lumbda2-b)/(2*a))
p22=((lumbda2-y*vj1)/(2*x*vj1))
V=6*(((x*p21)+y)*p21+z+((x*p22)+y)*p22+z)
delV=V-v1;
vj1=(vj1+((0.0955*delV)/(v1)))
end
t=2;
Ct=((a*(p11^2)+b*(p11)+c)+(a*(p12^2)+b*p12+c))*6
