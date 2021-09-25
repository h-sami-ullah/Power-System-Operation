clear
%-------------v-----del-----Pg-----Qg----Pd----Qd------------- 
bus = [ 1   1.04    0.00   0.00   0.00  0.00  0.00  0.00  0.00 1;
       	2   1.02533 0.00   1.63   0.00  0.00  0.00  0.00  0.00 2;
       	3   1.02536 0.00   0.85   0.00  0.00  0.00  0.00  0.00 2;
       	4   1.00    0.00   0.00   0.00  0.00  0.00  0.00  0.00 3;
       	5   1.00    0.00   0.00   0.00  0.90  0.30  0.00  0.00 3;
       	6   1.00    0.00   0.00   0.00  0.00  0.00  0.00  0.00 3;
       	7   1.00    0.00   0.00   0.00  1.00  0.35  0.00  0.00 3;
       	8   1.00    0.00   0.00   0.00  0.00  0.00  0.00  0.00 3;
        9   1.00    0.00   0.00   0.00  1.25  0.50  0.00  0.00 3]

        
% formation of y bus for nominal tap ratio i.e. a=1
%----------------r-------x------------b------------     
line = [1 4     0.0     0.0576      0.     1. 0. ;
        4 5     0.017   0.092       0.158  1. 0. ;
    	5 6     0.039   0.17        0.358  1. 0. ;
    	3 6     0.0     0.0586      0.     1. 0. ;
    	6 7     0.0119  0.1008      0.209  1. 0. ;
    	7 8     0.0085  0.072       0.149  1. 0. ;
        8 2     0.0     0.0625      0.     1. 0. ;
    	8 9     0.032   0.161       0.306  1. 0. ;
    	9 4     0.01    0.085       0.176  1. 0. ]

r = size(line);
p = r(1);
w = line(:,2 );
buses = max(w);

% b=zeros(1,buses);
ybus = zeros(buses,buses);
y = zeros(buses,buses);


for k= 1:p                    % finding the elements of ybus
    l= line(k,1); 
    m= line(k,2);
    
    y(l,m) = 1/(line(k,3)+ 1i*line(k,4));
    y(m,l) = y(l,m);
%     b(l) = b(l)+(i*line(k,5))/2;
%     b(m) = b(m)+(i*line(k,5))/2;
    
end

for i = 1:buses
    for j = 1:buses
        
        if i==j
            ybus(i,j) =  ybus(i,j)+sum(y(i,:)); %+ b(i);
        end
        
        if i~=j
            ybus(i,j) =  -1*y(i,j);
        end
    end
end
ybus;
b = -imag(ybus);

%formation of b' matrtix
b1=zeros(buses-1,buses-1);
for i = 1:buses-1
    for j = 1:buses-1
        b1(i,j) =b(i+1,j+1);
    end
end
b1;

%formation of b" matrtix
%assuming all the load buses are at last
b2=zeros(buses-3,buses-3);
for i = 1:buses-3
    for j = 1:buses-3
        b2(i,j) =b(i+3,j+3);
    end
end
b2;


v = bus(:,2);
del = bus(:,3);
Pg = bus(:,4);
Qg = bus(:,5);
Pd = bus(:,6);
Qd = bus(:,7);

Pspec = Pg-Pd;
Qspec = Qg-Qd;
iter = 1;
slack = 1;
tolerance = .01;
flag=1

while flag==1;  
    
    m = real(ybus);
    n = imag(ybus);
    P = zeros(buses,1);
    Q = zeros(buses,1);
    iter= iter+1;


for i=1:buses     %finding  bus real and reactive power 
    for j=1:buses
        P(i) = P(i)+ (v(i)*v(j)*(m(i,j)*cos(del(i)-del(j))+n(i,j)*sin(del(i)-del(j))));
        Q(i) = Q(i)+ (v(i)*v(j)*(m(i,j)*sin(del(i)-del(j))-n(i,j)*cos(del(i)-del(j))));
    end
end

P;
Q;
%finding del P by v
for i=1:(buses-1)   
    if(i<slack)
        delP(i,1)= Pspec(i)-P(i);
    else
        delP(i,1)=(Pspec(i+1)-P(i+1));
        
    end
    delPbyv(i,1)=delP(i,1)/v(i,1);
end

%finding del Q by v
c=0;
for i=1:buses
    if bus(i,10)==3
        c=c+1;
        delQ(c,1)= (Qspec(i)-Q(i));
        delQbyv(c,1)= delQ(c,1)/v(i,1);
    end
end

if max(abs(delP))>tolerance | max(abs(delQ))>tolerance
    flag=1;    % tolerance check
else
    flag=0; 
end

%calc correction vector
deldel = inv(b1)*delPbyv;  
delv = inv(b2)*delQbyv;

%updating values
for i=1:(buses-1)
    del(i+1,1)= del(i+1,1)+deldel(i,1);
end

c=0;
for i=1:buses
    if bus(i,10)==3
        c=c+1;
        v(i,1)=v(i,1)+delv(c,1);
    end
end

iter 
v
del
end


