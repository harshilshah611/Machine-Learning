function spectral_image(points)
    sigma=1;
    k=2;
    
    [m,n]=size(points);
    A=zeros(n*m,n*m);
    for i=1:m
        for j=1:n
            for k=1:m
                for l=1:n
                    A(((j-1)*m)+i,((l-1)*m)+k)=exp(-norm(points(((j-1)*m)+i)-points(((l-1)*m)+k))^2/(2*sigma^2));
                end
            end
        end
    end
    
    [~,an]=size(A);
    D=zeros(an,an);
    for i=1:an
        s=0;
        for j=1:an
            s=s+A(i,j);
        end
        D(i,i)=s;
    end
    L=D-A;
    
    [V,~]=eig(L);
    
    y=V(:,1:k);
    
    idx=kmeans(y,2);
    disp(size(idx));
    
    for i=1:m
        for j=1:n
            if idx(((j-1)*m)+i)==1
                scatter(i,j,[],[1,0,0],'filled');
            else
                scatter(i,j,[],[0,1,0],'filled');
            end
            hold on;
            
        end
    end
    camroll(-90);
end
