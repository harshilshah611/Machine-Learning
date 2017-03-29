[~, ~, raw] = xlsread('C:\Users\Harshil\Downloads\voting_train.csv','voting_train');
data = cell2mat(raw);
[~, ~, raw] = xlsread('C:\Users\Harshil\Downloads\voting_test.csv','voting_test');
testdata = cell2mat(raw);

clearvars raw R;

[m,n]=size(data);
for j=2:n
    for i=1:m
        if data(i,j)==-1
            data(i,j)=mode((data(:,j)));
        end
    end      
end
y=data(:,1);

p=zeros(n-1,4);
py=[0,0];

for i=1:m
    if y(i)==0
        py(1)=py(1)+1;
    else
        py(2)=py(2)+1;
    end
end

for j=2:n
    for i=1:m
        if data(i,j)==0 && y(i)==0
            p(j-1,1)=p(j-1,1)+1;
        elseif data(i,j)==0 && y(i)==1
            p(j-1,2)=p(j-1,2)+1;
        elseif data(i,j)==1 && y(i)==0
            p(j-1,3)=p(j-1,3)+1;
        elseif data(i,j)==1 && y(i)==1
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

%%disp(testdata)
[m,n]=size(testdata);
%%disp(testdata)
y=testdata(:,1);

miss=0;
c=0;
for i=1:m
    prob0=py(1);
    prob1=py(2);
    flag=1;
    for j=2:n
        if testdata(i,j)==-1
            flag=0;
        end
        if testdata(i,j)==0
            prob0=prob0*p(j-1,1);
            prob1=prob1*p(j-1,2);
        elseif testdata(i,j)==1
            prob0=prob0*p(j-1,3);
            prob1=prob1*p(j-1,4);
        end
        %%disp([prob0 prob1 y(i) testdata(i,j) i j])
        %%temp=input('A pause');
    end
    if flag==1
        c=c+1;
        %%disp([prob0 prob1 y(i)])
        %%temp=input('A pause');
        if prob0>=prob1 && y(i)~=0
            miss=miss+1;
        elseif prob0<prob1 && y(i)~=1
            miss=miss+1;
        end
    end
end

disp((1-(miss/c))*100)