%input:  training data and c as in x and c

%output: the w,b of the the trained classifier
function [w,b] = plotsvm_slack(x,c)
[numpoints, numcols] = size(x);
%find the max-margin classifier

f=([zeros(1,58) c*ones(1,numpoints)]');
y = x(:,numcols);
lb = zeros(numcols+numpoints,1);
for j=1:58
    lb(j,1)=-inf;
end
A = [x(:,1).*y x(:,2).*y x(:,3).*y x(:,4).*y x(:,5).*y x(:,6).*y x(:,7).*y x(:,8).*y x(:,9).*y x(:,10).*y x(:,11).*y x(:,12).*y x(:,13).*y x(:,14).*y x(:,15).*y x(:,16).*y x(:,17).*y x(:,18).*y x(:,19).*y x(:,20).*y x(:,21).*y x(:,22).*y x(:,23).*y x(:,24).*y x(:,25).*y x(:,26).*y x(:,27).*y x( :,28).*y x(:,29).*y x(:,30).*y x(:,31).*y x(:,32).*y x(:,33).*y x(:,34).*y x(:,35).*y x(:,36).*y x(:,37).*y x(:,38).*y x(:,39).*y x(:,40).*y x(:,41).*y x(:,42).*y x(:,43).*y x(:,44).*y x(:,45).*y x(:,46).*y x(:,47).*y x(:,48).*y x(:,49).*y x(:,50).*y x(:,51).*y x(:,52).*y x(:,53).*y x(:,54).*y x(:,55).*y x(:,56).*y x(:,57).*y y diag(ones(1,numpoints))];

r = quadprog(diag([ones(1,57) 0 zeros(1,numpoints)]'),f,-A,-1*ones(numpoints,1));

w=z(1:57);
b=z(58);
