[~, ~, raw] = xlsread('C:\Users\Harshil\Downloads\voting_train.csv','voting_train');
data = cell2mat(raw);
[~, ~, raw] = xlsread('C:\Users\Harshil\Downloads\voting_test.csv','voting_test');
testdata = cell2mat(raw);

clearvars raw R;

[m,n]=size(data);
c=0;
for i=1:m
    j=1;
    while j<=n
        if data(i,j)==-1
            c=c+1;
            j=n;
        end
        j=j+1;
    end
end
c=m-c;

data1=zeros(c,n);
k=1;
for i=1:m
    j=1;
    flag=0;
    while j<=n
        if data(i,j)==-1
            flag=1;
            j=n;
        end
        j=j+1;
    end
    if flag==0
        data1(k,:)=data(i,:);
        k=k+1;
    end
end
y=data1(:,1);

p=zeros(n-1,4);
py=[0,0];

for i=1:c
    if y(i)==0
        py(1)=py(1)+1;
    else
        py(2)=py(2)+1;
    end
end

for j=2:n
    for i=1:c
        if data1(i,j)==0 && y(i)==0
            p(j-1,1)=p(j-1,1)+1;
        elseif data1(i,j)==0 && y(i)==1
            p(j-1,2)=p(j-1,2)+1;
        elseif data1(i,j)==1 && y(i)==0
            p(j-1,3)=p(j-1,3)+1;
        elseif data1(i,j)==1 && y(i)==1
            p(j-1,4)=p(j-1,4)+1;
        end
    end
end
p(:,1)=p(:,1)/py(1);
p(:,2)=p(:,2)/py(2);
p(:,3)=p(:,3)/py(1);
p(:,4)=p(:,4)/py(2);

py=py/c;

disp(p)
[m,n]=size(testdata);
c=0;
for i=1:m
    j=1;
    while j<=n
        if testdata(i,j)==-1
            c=c+1;
            j=n;
        end
        j=j+1;
    end
end
c=m-c;

testdata1=zeros(c,n);
k=1;
for i=1:m
    j=1;
    flag=0;
    while j<=n
        if testdata(i,j)==-1
            flag=1;
            j=n;
        end
        j=j+1;
    end
    if flag==0
        testdata1(k,:)=testdata(i,:);
        k=k+1;
    end
end
y=testdata1(:,1);

miss=0;
for i=1:c
    prob0=py(1);
    prob1=py(2);
    for j=2:n
        if testdata1(i,j)==0
            prob0=prob0*p(j-1,1);
        elseif testdata1(i,j)==1
            prob0=prob0*p(j-1,3);
        end
        if testdata1(i,j)==0
            prob1=prob1*p(j-1,2);
        elseif testdata1(i,j)==1
            prob1=prob1*p(j-1,4);
        end
    end   
    
    if prob0>=prob1 && y(i)~=0
        miss=miss+1;
    elseif prob0<prob1 && y(i)~=1
        miss=miss+1;
    end
end

disp((1-(miss/c))*100)