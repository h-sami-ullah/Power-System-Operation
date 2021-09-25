function [p1,lamda1,cost1]=lamda_iteration(cost1,pu1,pl1,pd1,lamda1)
n1=length(pl1);
dp1=500;
for i1=1:n1
    a1(i1,1)=cost1(i1,1);
    b1(i1,1)=cost1(i1,2);
    y1(i1,1)=cost1(i1,3);
end	
while(abs(dp1)>5)
p1=(lamda1-b1)./(2*y1);
for j1=1:n1
    if(p1(j1,1)>pu1(1,j1))
        p1(j1,1)=pu1(1,j1);
    end
    if(p1(j1,1)<pl1(1,j1))
        p1(j1,1)=pl1(1,j1);
    end        
end
dp1=pd1-sum(p1);
dlamda1=dp1/sum(1./(2*y1));
lamda1=lamda1+dlamda1;
end
cost1=sum( [sum(a1) sum(b1.*p1) sum(y1.*p1.*p1)]);
end
