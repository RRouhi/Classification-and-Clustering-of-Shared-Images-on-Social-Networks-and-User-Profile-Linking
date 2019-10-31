function [F,pr,re,ac,ARI,sp,fpr,N_R,PURITY]=clsr_eval(ng,N,CL_G,img_user)
%ng is the number of classes
%N is the number of images

nd=numel(CL_G);
i=1;
j=0;
while i<N
     CL_T{1,j+1}=[i:i+img_user(j+1)-1]';
     i=i+img_user(j+1);
     j=j+1;
end

for i=1:numel(CL_G)
     imax1 = CL_G{1,i};
     out{i,1}=nchoosek(imax1,2);
end

IDX=zeros(1,2);
for i=1:numel(CL_G)
    IDX=[IDX;out{i,1}];
end

for i=1:numel(CL_T)
    imax2 = CL_T{1,i};
    T{i,1}=nchoosek(imax2,2);
end

Tr=zeros(1,2);
for i=1:numel(CL_T)
    Tr=[Tr;T{i,1}];
end

A=intersect(IDX,Tr,'rows','legacy');%TP
B=setdiff(IDX,Tr,'rows','legacy');%FP
C=setdiff(Tr,IDX,'rows','legacy');%FN
% % %https://stats.stackexchange.com/questions/15158/precision-and-recall-for-clustering
% % %The only thing that is potentially tricky 
% % %is that a given point may appear in multiple clusters.
% % %The authors appear to look at all pairs of points, 
% % %say (x,y), and ask whether one of the clusters that contains
% % %point x also contains point y. A true positive (tp) is when this
% % %is both the case in truth and for the inferred clusters. A false positive
% % %(fp) would be when this is not the case in truth but is the case for the
% % %inferred clusters. A false negative (fn) would be when this is the case
% % %in truth but not for the inferred clusters.
% Then precision = tp / (tp + fp) and recall = tp / (tp + fn), Specificity=TN / (FP + TN)
%FPR=FP/(FP+TN)

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

% 
% for i=1:numel(CL_T)-1
%     for j=i+1:numel(CL_G)
%         Int_mat(i,j)=numel(intersect(CL_T{1,i},CL_G{1,j}));
%         Int_mat(j,i)=Int_mat(i,j);
%     end
% end
% i=1;
% j=1;
% for k=2:numel(img_user)
%      TR(i:i+img_user(k)-1,1)=ones(img_user(k),1)*j;
%      i=i+img_user(k);
%      j=j+1;
% end
% 
% [ARI1, RI, JaccardCoef] = AdRandIdx(CL_G, TR);

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
PURITY=sum(Purity)/numel(CL_G)*100;

