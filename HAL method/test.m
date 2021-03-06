

function [A,DIST,Mark,C_T,I_O]=test(C1,C2,dis,CL1,CL2,DIST,Mark,list,thr,dim,C_T,I_O,omega)
   [T_intra,DIST,Mark,C_T,I_O]=th_comp(CL1,CL2,DIST,Mark,list,dim,C_T,I_O,omega);
   thr_se=max(thr,T_intra);
   if (1-dis(C1,C2))>thr_se %if their correlation (1-dis) is higher than ...
       A=1;
   else
      A=0;
   return;
   end
end%end function

function [T_intra,DIST,Mark,C_T,I_O]=th_comp(CL1,CL2,DIST,Mark,list,dim,C_T,I_O,omega)

C1=sort(CL1);
D_1=DIST(C1,C1);
D_up_1=triu(ones(size(D_1,1)));
D_up_1(D_up_1==0)=100;
DD1=D_1;
D_1(D_1==0)=1;
Mask_1=D_up_1.*D_1;
Mask_1(logical(eye(size(D_1,1))))=0;
[row,col]=find(Mask_1==1);
ind1=C1(col);
ind1=unique(ind1);
if numel(ind1)>1
   ind2=C1(row);
   ind2=unique(ind2);
   ind=[ind1;ind2];
   ind=unique(sort(ind));
   X=zeros(dim(1)*dim(2),numel(ind));
   T1=tic;
   for i=1:numel(ind)
       path1=fullfile(list(ind(i)).folder,list(ind(i)).indx);
       path1=strcat(path1,'.mat');% load RNs
       clear r; % to be sure the last data is not accessible 
       load(path1);% select the directory of databse on the computer
%            OUT1=imresize(r.RN,dim);   
       X(:,i)=r(:);
   end
   I_O=I_O+toc(T1);
   T2=tic;
 D1=1-cross_corr(X);
 DIST(ind,ind)=D1;
   C_T=toc(T2)+C_T;
 D1=DIST(C1,C1);
else
 D1=DD1;
end
D1(logical(eye(size(D1,1))))=0;


clear ind1 ind2 row col ind X 
C2=sort(CL2);
D_2=DIST(C2,C2);
D_up_2=triu(ones(size(D_2,1)));
D_up_2(D_up_2==0)=100;
DD2=D_2;
D_2(D_2==0)=1;
Mask_2=D_up_2.*D_2;
Mask_2(logical(eye(size(D_2,1))))=0;
[row,col]=find(Mask_2==1);
ind1=C2(col);
ind1=unique(ind1);
if numel(ind1)>1
   ind2=C2(row);
   ind2=unique(ind2);
   ind=[ind1;ind2];
   ind=unique(sort(ind));
   X=zeros(dim(1)*dim(2),numel(ind));
   T3=tic;
   for i=1:numel(ind)
       path1=fullfile(list(ind(i)).folder,list(ind(i)).indx);
       path1=strcat(path1,'.mat');% load RNs
       clear r; % to be sure the last data is not accessible 
       load(path1);% select the directory of databse on the computer
%            OUT1=imresize(r.RN,dim);   
       X(:,i)=r(:);
   end
   I_O=toc(T3)+I_O;
   T4=tic;
   D2=1-cross_corr(X);
   C_T=toc(T4)+C_T;
   DIST(ind,ind)=D2;
   D2=DIST(C2,C2);
else
   D2=DD2;
end
   D2(logical(eye(size(D2,1))))=0;
 
%% Compute the adaptive threshold
% % omega=0.17;%if it is less, it allows more RNs to be merged, the recall increases while the precision decreases,
%we prefer to have higher precision than recall, so it shoeld be somehow high  
% DIST=normalize(DIST);
% if DIST(1,1)==1
%     DIST=1-DIST;%get distance matrix rather than correlation
% end
n_c1=numel(C1);
n_c2=numel(C2);
D1=1-D1;
D2=1-D2;
var1=mean(D1(:));
var2=mean(D2(:));
s1=omega*(sqrt(n_c1*n_c2*var1*var2));
s2=sqrt((((n_c1-1)*var1)+1)*(((n_c2-1)*var2)+1));
T_intra=s1/s2;
Mark(C1,C1)=1;
Mark(C2,C2)=1;
end
