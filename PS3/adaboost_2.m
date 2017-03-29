function acc=adaboost_2()
    A=importdata('heart_train.data');
    B=importdata('heart_test.data');
    
    [r,c]=size(A);
    
    y=A(:,1);
    y(y==0)=-1;
    
    n=20;
    
    hyps=zeros(n,3);
    w=zeros(n+1,r);
    w(:,:)=1/r;
    
    alphas=zeros(1,n);
    
    for m=1:n
        minw=1;
        for i=2:c
            currw=weight(i,1,A,w,m);
            %disp(currw)
            if currw<minw
                hyps(m,:)=[i -1 -1];
                minw=currw;
            end
            currw=weight(i,2,A,w,m);
            if currw<minw
                hyps(m,:)=[i -1 1];
                minw=currw;
            end
            currw=weight(i,3,A,w,m);
            if currw<minw
                hyps(m,:)=[i 1 -1];
                minw=currw;
            end
            currw=weight(i,4,A,w,m);
            if currw<minw
                hyps(m,:)=[i 1 1];
                minw=currw;
            end
        end
        e=minw;
        alpha=0.5*log((1-e)/e);
        Z=2*sqrt(e*(1-e));
        disp([e alpha])
        disp(hyps(m,:))
        for i=1:r
            if A(i,hyps(m,1))==0
                w(m+1,i)=w(m,i)*exp(-1*y(i)*alpha*hyps(m,2))/Z;
            else
                w(m+1,i)=w(m,i)*exp(-1*y(i)*alpha*hyps(m,3))/Z;
            end
        end
        %disp(w(m+1,:));
        alphas(1,m)=alpha;
    end
    
    [r,c]=size(B);
    
    y=B(:,1);
    y(y==0)=-1;
    miss=0;
    for i=1:r
        s=0;
        for j=1:m
            %disp(B(i,hyps(j,1)))
            if B(i,hyps(j,1))==0
                %disp('here');
                s=s+(alphas(1,j)*hyps(j,2));
            else
                %disp('there');
                s=s+(alphas(1,j)*hyps(j,3));
            end
        end
        %disp(s)
        %disp([i y(i) sign(s)]) 
        if y(i)~=sign(s)
            miss=miss+1;
        end
    end
    
    acc=((1-(miss/r))*100);
end

function currw=weight(i,k,A,w,m)
    [r,~]=size(A);
    
    y=A(:,1);
    y(y==0)=-1;
    
    currw=0;
    for l=1:r
        if A(l,i)==0
            if k==1 || k==2
                if y(l)~=-1
                    currw=currw+w(m,i);
                end
            else
                if y(l)~=1
                    currw=currw+w(m,i);
                end
            end
        else
            if k==1 || k==3
                if y(l)~=-1
                    currw=currw+w(m,i);
                end
            else
                if y(l)~=1
                    currw=currw+w(m,i);
                end
            end
        end
    end
end