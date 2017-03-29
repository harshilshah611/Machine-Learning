function acc=coordinate_again()
    A=importdata('heart_train.data');
    B=importdata('heart_test.data');
    [r,c]=size(A);
    
    y=A(:,1);
    y(y==0)=-1;
    sl=51;
    alphas=randi([-1 1],1,4*(c-1));
    [~,n]=size(alphas);
    
   
    iter=0;
    i=1;
  
    
    while sl>50
        iter=iter+1;
        num=0;
        dem=0;
        numc=0;
        demc=0;
        for l=1:r
            %disp([i l hyps(i,l,A) y(l)])
            if hyps(i,l,A)==y(l)
                %disp('here')
                snum=0;
                numc=numc+1;
                for j=1:n
                    if j~=i
                        snum=snum+(alphas(j)*hyps(j,l,A));
                    end
                end
                num=num+exp(-1*y(l)*snum);
            end
            %temp=input('pause');
            
        end
        
        for l=1:r
            sdem=0;
            if hyps(i,l,A)~=y(l)
                demc=demc+1;
                for j=1:n
                    if j~=i
                        sdem=sdem+(alphas(j)*hyps(j,l,A));
                    end
                end
                dem=dem+exp(-1*y(l)*sdem);
            end
        end
        %disp([numc num demc dem]);
        %temp=input('pause');
        alphas(1,i)=0.5*log(num/dem);
        disp(sl);
        sl=0;
        for l=1:r
            se=0;
            for j=1:n
                se=se+alphas(j)*hyps(j,l,A);
            end
            sl=sl+exp(-1*y(l)*se);
        end
        i=i+1;
        if i>88
            i=1;
        end
%         if iter>200
%             presl=sl;
%         end
        %disp(sum(alphas));
        %disp([(round(presl*10)/10) (round(sl*10)/10)])
    end
    disp(sl);
    disp(iter)
    %%testing accuracy
    [r,~]=size(B);
    
    y=B(:,1);
    y(y==0)=-1;
    
    miss=0;
    for i=1:r
        s=0;
        for j=1:n
            s=s+alphas(j)*hyps(j,i,B);
        end
        if s*y(i)<0
            miss=miss+1;
        end
    end
    
    disp(alphas);
    acc=(1-(miss/r))*100;
end

function label=hyps(i,j,A)
    %i is the hypothesis number
    %j is the data point
    %A is the data set
    
    split=floor(i/4-0.1)+2;
    k=i-4*(split-2);
    %disp([i split A(j,split) k]);
    if A(j,split)==0
        if k==1 || k==2
            %disp('here')
            label=-1;
        else
            %disp('there')
            label=1;
        end
    else
        if k==1 || k==3
            label=-1;
        else
            label=1;
        end
    end
    %disp(label)
    %temp=input('a pause');
end