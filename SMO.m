clc;
data=dlmread("SMO_data.txt");
xd=data(:,1:2);
x=xd';
yd=data(:,3);
y=yd';
[r,c]=size(x);
for l=1:c
    if y(l)==0
        y(l)=-1;
    end
end
ep=0.05;
b=0;
al=rand(1,c-1);
al(end+1)=-sum(al.*y(1:c-1))/y(c);
%disp(al)
ay=al.*y;
%disp(sum(ay))
cep=0.1;
while(cep>ep)
w=[];
for l=1:2
    w(end+1)=sum(ay.*x(l,:));
end
kkt=[];
for l=1:c
   dot=sum(w'.*x(:,l));
   s2=y(l)*dot;
   s3=s2-1;
   kkt(end+1)=al(l)*s3;
end
%disp(kkt)
%disp(find(kkt == max(kkt(:))))
i1=find(kkt == max(kkt(:)));
x1=x(:,i1);
Ei=[];
for p=1:c
    Eis=[];
    for k=1:c
        Eis(end+1)=ay(k)*sum(x(:,p).*x(:,k));
    end
    Ei(end+1)=sum(Eis)-y(p);
end
%disp(Ei)
E1s=[];
for k=1:c
    E1s(end+1)=ay(k)*sum(x1.*x(:,k));
end
E1=sum(E1s)-y(i1);
ei=(E1-Ei);
i2=find(ei == max(ei(:)));
x2=x(:,i2);
k=sum(x1.*x1)+sum(x2.*x2)-2*sum(x1.*x2);
E2s=[];
for k=1:c
    E2s(end+1)=ay(k)*sum(x2.*x(:,k));
end
E2=sum(E2s)-y(i2);
al2n=al(i2)+(y(i2)*E2)/k;
al1n=al(i1)+y(i1)*y(i2)*(al(i2)-al2n);
al(i1)=al1n;
al(i2)=al2n;
for l=1:c
    if al(l)<ep
        al(l)=0;
    end
end
bias=[];
for l=1:c
    if al(l)>0
       bias(end+1)=y(l)-sum(w'.*x(:,l));
    end
end
tb=mean(bias);
tp=0;
fp=0;
tn=0;
fn=0;
for l = 1:c
    output = sign(sum(w'.*x(:,l)) + tb);
    if output == 1
        if output == y(l)
            tp = tp + 1;
        else
            fp = fp + 1;
        end
    else
        if output == y(l)
            tn = tn + 1;
        else
            fn = fn + 1;
        end
    end
end
ac = (tp + tn) / (tp + tn + fn + fp);
disp(ac)
cep=1-ac;
end
disp(ac)