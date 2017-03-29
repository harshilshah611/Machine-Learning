function acc=adaboost()
A=importdata('heart_train.data');
B=importdata('heart_test.data');
[r,c]=size(A);

y=A(:,1);
y(y==0)=-1;


n=5;


hyps=zeros(n,7);
w=zeros(n+1,r);
w(:,:)=1/r;
ws=zeros(n,22*21*21);
wsc=1;
alphas=zeros(1,n);

for m=1:n
    minw=1;
    wsc=1;
    for i=2:c
        for j=i+1:c
            for k=j:c
                currw=weight(i,j,k,A,w,m);
                ws(m,wsc)=currw(1);
                wsc=wsc+1;
                %disp(currw)
                if currw(1)<minw
                    hyps(m,:)=[i,j,k currw(2:5)];
                    minw=currw(1);
                end
           
                currw=weight(i,k,j,A,w,m);
                if currw(1)<minw
                    hyps(m,:)=[i,k,j currw(2:5)];
                    minw=currw(1);
                end
                ws(m,wsc)=currw(1);
                wsc=wsc+1;
                
                currw=weight(j,i,k,A,w,m);
                if currw(1)<minw
                    hyps(m,:)=[j,i,k currw(2:5)];
                    minw=currw(1);
                end
                ws(m,wsc)=currw(1);
                wsc=wsc+1;
                
                currw=weight(j,k,i,A,w,m);
                if currw(1)<minw
                    hyps(m,:)=[j,k,i currw(2:5)];
                    minw=currw(1);
                end
                ws(m,wsc)=currw(1);
                wsc=wsc+1;
                
                currw=weight(k,i,j,A,w,m);
                if currw(1)<minw
                    hyps(m,:)=[k,i,j currw(2:5)];
                    minw=currw(1);
                end
                ws(m,wsc)=currw(1);
                wsc=wsc+1;
                
                currw=weight(k,j,i,A,w,m);
                if currw(1)<minw
                    hyps(m,:)=[k,j,i currw(2:5)];
                    minw=currw(1);
                end
                ws(m,wsc)=currw(1);
                wsc=wsc+1;
            end
        end
    end
    e=minw;
    alpha=(0.5)*log((1-e)/e);
    alphas(1,m)=alpha;
    Z=2*sqrt(e*(1-e));
    disp([e alpha Z])
    %disp(m)
    disp(hyps)
    
    for l=1:r
        %disp([l A(l,hyps(m,1)) A(l,hyps(m,2)) A(l,hyps(m,3))])
        if A(l,hyps(m,1))==0 && A(l,hyps(m,2))==0
            w(m+1,l)=w(m,l)*exp(-1*y(l)*hyps(m,4)*alpha)/Z;
            %disp([l w(m+1,l)]);
        elseif A(l,hyps(m,1))==0 && A(l,hyps(m,2))==1
            w(m+1,l)=w(m,l)*exp(-1*y(l)*hyps(m,5)*alpha)/Z;
        elseif A(l,hyps(m,1))==1 && A(l,hyps(m,3))==0
            w(m+1,l)=w(m,l)*exp(-1*y(l)*hyps(m,6)*alpha)/Z;
            %disp([l w(m+1,l)]);
        elseif A(l,hyps(m,1))==1 && A(l,hyps(m,3))==1
            w(m+1,l)=w(m,l)*exp(-1*y(l)*hyps(m,7)*alpha)/Z;
        end
    end
    
    %disp(w)
    %t=input('enter a number');
end

[r,~]=size(B);
y=B(:,1);
y(y==0)=-1;

miss=0;
for i=1:r
    s=0;
    for m=1:n
        if B(i,hyps(m,1))==0 && B(i,hyps(m,2))==0
            s=s+alphas(1,m)*hyps(m,4);
        elseif B(i,hyps(m,1))==0 && B(i,hyps(m,2))==1
            s=s+alphas(1,m)*hyps(m,5);
        elseif B(i,hyps(m,1))==1 && B(i,hyps(m,3))==0
            s=s+alphas(1,m)*hyps(m,6);
            %disp([l w(1,l)]);
        elseif B(i,hyps(m,1))==1 && B(i,hyps(m,3))==1
            s=s+alphas(1,m)*hyps(m,7);
        end
    end
    if s*y(i)<0
        miss=miss+1;
    end
end

disp((1-(miss/r))*100);

acc=ws;
end

function currw = weight(i,j,k,A,w,m)
[r,~]=size(A);

y=A(:,1);
y(y==0)=-1;

labels=zeros(1,4);
%t=input('input a number');
%disp([i j k])
cw=0;
for l=1:r
    if A(l,i)==0 && A(l,j)==0
        labels(1,1)=labels(1,1)+w(m,l)*y(l);
    elseif A(l,i)==0 && A(l,j)==1
        labels(1,2)=labels(1,2)+w(m,l)*y(l);
    elseif A(l,i)==1 && A(l,k)==0
        labels(1,3)=labels(1,3)+w(m,l)*y(l);
    elseif A(l,i)==1 && A(l,k)==1
        labels(1,4)=labels(1,4)+w(m,l)*y(l);
    end
end
%disp(labels)
labels(labels>0)=1;
labels(labels<0)=-1;


for l=1:r
    if A(l,i)==0 && A(l,j)==0
        if y(l)~=labels(1,1)
            cw=cw+w(m,l);
        end
    elseif A(l,i)==0 && A(l,j)==1
        if y(l)~=labels(1,2)
            cw=cw+w(m,l);
        end
    elseif A(l,i)==1 && A(l,k)==0
        if y(l)~=labels(1,3)
            cw=cw+w(m,l);
        end
    elseif A(l,i)==1 && A(l,k)==1
        if y(l)~=labels(1,4)
            cw=cw+w(m,l);
        end
    end
end
%disp(labels)
currw=[cw labels(1,:)];
end