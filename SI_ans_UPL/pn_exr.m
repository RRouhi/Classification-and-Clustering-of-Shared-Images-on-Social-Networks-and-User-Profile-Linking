function [SP]=pn_exr(CL,list,dim)
C=length(CL);
for i=1:C
    indx=CL{1,i};
    d=numel(indx);
    S=zeros(dim(1),dim(2));
    for t=1:d
       path=fullfile(list(indx(t)).folder,list(indx(t)).indx);
       path=strcat(path,'.mat');% load RNs
       clear r;
       load(path);% select the directory of databse on the computer
%      OUT=imresize(r.RN,dim);
       OUT=r;
       S=S+OUT;% n(t): the index of image in clustering output
    end
    SP(i,1:dim(1)*dim(2))=S(:)';
end
end