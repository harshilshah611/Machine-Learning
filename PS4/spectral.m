function spectral(points)
    sigma=0.1;
    k=2;
    
    [~,n]=size(points);
    A=zeros(n,n);
    for i=1:n
        for j=1:n
            A(i,j)=exp(-norm(points(:,i)-points(:,j))^2/(2*sigma^2));
        end
    end
    
    [~,n]=size(A);
    D=zeros(n,n);
    for i=1:n
        s=0;
        for j=1:n
            s=s+A(i,j);
        end
        D(i,i)=s;
    end
    L=D-A;
    
    [V,D]=eig(L);
    [~,vc]=size(V);
    y=[V(:,2)];
    
    idx=kmeans(y,2);
    
    for i=1:n
        if idx(i)==1
            scatter(points(1, i),points(2, i),[],[1,0,0],'filled');
        elseif idx(i)==2
            scatter(points(1, i),points(2, i),[],[0,1,0],'filled');
        end
        hold on;
    end

end
