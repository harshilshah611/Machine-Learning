%input: c and sigma both parameters of slack and Gaussian variance

%output: accuracy of the test for given pair of c and sigma
function accuracy = svmslack_dual(c,sigma)

	data = dlmread('spambase_train.data',',');
	[numpoints, numcols] = size(data);
	%data has the training data points

	%to convert class labels to {-1,1}
	y=data(:,numcols);
	y(y==0)=-1;
	data=[data(:,(1:numcols-1)) y];

	%H argument of quadprog 
	H = zeros(numpoints);
	for j=1:numpoints
		for k=1:numpoints
			H(j,k) = data(j, numcols) * data(k, numcols) * kernel(data(j,1:numcols-1), data(k, 1:numcols-1),sigma);		%kernel function called here
		end
	end

	%Aeq argument of quadprog
	Aeq = zeros(numpoints,numpoints);
	for k=1:numpoints
		Aeq(1,k) = data(k,numcols);
	end

	%ub argument of quadprog
	ub = zeros(numpoints,1);
	for j=1:numpoints
		ub(j,1) = c;
	end

	[x,~,~] = quadprog(H,-1*ones(numpoints,1),zeros(numpoints),zeros(numpoints,1),Aeq,zeros(numpoints,1),zeros(numpoints,1),ub);

	%lambda is the output of the dual function of SVM with slack and Gaussian kernel
	lamda = x;

	%b is found using complementary slackness
	index = find(lamda>0,1);
	b=0;
	for j=1:numpoints
		b=b-lamda(j)*data(j,numcols)*kernel(data(index,1:numcols-1),data(j,1:numcols-1),sigma);
	end
	b=data(index,numcols)+b;


	%test_data is the test data used to calculate the accuracy of the trained classifier
	test_data = dlmread('spambase_test.data',',');
	[t_points, t_cols] = size(test_data);
	 
	y=test_data(:,t_cols);
	y(y==0)=-1;
	test_data=[test_data(:,(1:t_cols-1)) y];
	 
	count = 0; 
	for j=1:t_points
		f_x = b;
		for k = 1:numpoints
			f_x = f_x + lamda(k)*data(k,numcols)*kernel(test_data(j,1:numcols-1),data(k,1:numcols-1),sigma);
		end
		if(f_x * test_data(j,t_cols) >= 0)
			count = count+1;
		end
	end
	accuracy = count/t_points*100;

end

function k = kernel(x1,x2,sigma)
	distance = 0;
	[~,numcols] = size(x1);
	for j=1:numcols-1
		distance = distance + power(x1(1,j) - x2(1,j),2);
	end
	k = exp(-distance/(2*power(sigma,2)));
end
