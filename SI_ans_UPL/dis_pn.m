function [Dis_cor]=dis_pn(SPN,list,N,dim,k)
    for t=1:N
        path=fullfile(list(t).name);
        clear r;
        load(path);% select the directory of databse on the computer
%        OUT=imresize(r.RN,dim);
        X(1,1:dim(1)^2)=r(:)';
        Dis_cor(t,1:k)=1-cross_corr(X',SPN');
        clear X;
    end
end
