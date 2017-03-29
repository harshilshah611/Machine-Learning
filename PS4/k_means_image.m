function k_means_image(points)
    k=2;
    [m,n]=size(points);
    points=reshape(points',1,m*n);
    idx=kmeans(points,k);
    disp(size(idx))
    [~,pn]=size(points);
    for x=1:pn
        %%disp([ceil(x/n) x-((ceil(x/n)-1)*n)])
        if idx(x)==1
            scatter(ceil(x/n),(x-((ceil(x/n)-1)*n)),[],[1,0,0],'filled');
        else
            scatter(ceil(x/n),(x-((ceil(x/n)-1)*n)),[],[0,1,0],'filled');
        end
        hold on;
    end
    camroll(-90);
end
