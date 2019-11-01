function [F,pr,re,ac,ARI,sp,fpr,N_R,PURITY]=clsr_eval(ng,N,CL_G,CL_T)
%ng is the number of classes
%N is the number of images

nd=numel(CL_G);

for i=1:numel(CL_G)
     imax1 = CL_G{1,i};
     if ~isempty (imax1)
        out{i,1}=nchoosek(imax1,2);
     else
        out{i,1}=[]; 
     end
end

IDX=zeros(1,2);
for i=1:numel(CL_G)
    if numel(out{i,1})==1
      jh=[out{i,1};out{i,1}]; 
      jh=jh';
    else
      jh=out{i,1};
    end
      IDX=[IDX;jh];
end

for i=1:numel(CL_T)
    imax2 = CL_T{1,i};
    T{i,1}=nchoosek(imax2,2);
end

Tr=zeros(1,2);
for i=1:numel(CL_T)
    if numel(T{i,1})==1
       tj=[T{i,1};T{i,1}];
       tj=tj';
    else
        tj=T{i,1};
    end
      Tr=[Tr;tj];
end

A=intersect(IDX,Tr,'rows','legacy');%TP
B=setdiff(IDX,Tr,'rows','legacy');%FP
C=setdiff(Tr,IDX,'rows','legacy');%FN
a=size(A,1);%TP
b=size(B,1);%FP
c=size(C,1);%FN
d=nchoosek(N,2)-(a+b+c);%TN

pr=a/(a+b);%Precision
re=a/(a+c);%Recall or tpr
F=2*pr*re/(pr+re);%F_measure
ac=(a+d)/(a+b+c+d);%Accuracy or rand index
A1=(nchoosek(N,2)*(a+d))-((a+b)*(a+c)+(c+d)*(b+d));
A2=((nchoosek(N,2))^2)-((a+b)*(a+c)+(c+d)*(b+d));
ARI=A1/A2;
sp=d/(b+d);%Specificity
fpr=b/(b+d);%1-specificity
N_R=nd/ng;

%Purity
for i=1:numel(CL_G)
    pu(i)=0;
    for j=1:numel(CL_T)
        in=intersect(CL_G{1,i},CL_T{1,j});
        if ~isempty(in)
           pu(i)=max(pu(i),numel(in));
        end
        Purity(i)=pu(i)/numel(CL_G{1,i});
    end
end
PURITY=sum(Purity)/numel(CL_G);



