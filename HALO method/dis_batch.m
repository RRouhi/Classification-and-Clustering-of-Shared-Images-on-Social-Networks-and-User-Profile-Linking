%calculates distances among all the images in the dataset based on
%partitioning

function [prt,CL_new,DIST,L,Mark,Out,Smpl]=dis_batch(list,N,q,CL,f,flag,DIST,dim,prt,omega,n,L,Mark,thr,MinPts,eps,op,pm,tot)
d=1;
Id_r={};%to keep randomely the indices in the partitions
% tot=1:N;
CL_new={};%to keep all the obtained clusters from all the batches
if flag && isempty(CL)
    for i=1:floor(N/q)
        Id_r{1,i}=randsample(tot,q);%sort
        tot=setdiff(tot,Id_r{1,i});
    end
else
   tot=1:N;
   for i=1:floor(N/q)
       Id_r{1,i}=tot(1:1+q-1);
       tot=sort(setdiff(tot,Id_r{1,i}));
   end
end

p=N/q;
if rem(N,q)~=0
   prt(1:floor(p))=q;
   prt(floor(p)+1)=rem(N,q);
   Id_r{1,floor(p)+1}=tot;
else
    prt(1:p)=q;
end
%%
z=0;
CL_new=cell(1,numel(prt));
for g=1:numel(prt)
    if (f && isempty(CL))
         S_pn_O=zeros(prt(g),dim(1)*dim(2));
         h=Id_r{1,g}; 
         h=h';
         for i=1:prt(g)
             path=fullfile(list(h(i)).folder,list(h(i)).indx);
             clear r R;
             load(path);
             disp(['Reading: image(',num2str(h(i)),' out of ',num2str(sum(prt)),'...)']);
%              cl_r=WienerInDFT(r,std2(r));
%              S_pn_O(i,:)=cl_r(:)';
             R=r;
             S_pn_O(i,:)=R(:)';
         end
         disp(['Reading: Part(',num2str(g),' out of ',num2str(numel(prt)),'...)']);
         clear D
         disp('Correlation Computation ...');
         D=1-cross_corr(S_pn_O');
         if op
             [~, varType]=DBSCAN_Clustering(D,MinPts,eps);%
             [k1,~]=find(varType==1);%find normal
         else
             [anomaly]=DKNN(20,D);
             [k1,~]=find(anomaly<=pm);%find normal
             varType=ones(size(D,1),1);
             k2=setdiff(1:N,k1);
             varType(k1)=1;
             varType(k2)=-1;
         end
         if ~isempty(k1)
            [Nor]=h(varType==1);
            Out{g}=setdiff(h,Nor);
            Smpl{g}=h;%all the samples in a batch, only for the first interation
         else
             Nor=h;
         end
%%
         if flag
            DIST(h,h)=D;
            Mark(h,h)=1;
         end
         CL_O=num2cell(Nor);%the old cluster%for the first time only
         CL_O=CL_O';
         h=Nor;
         if ~isempty(k1)
            SS=zeros(numel(k1),dim(1)*dim(2));
            SS=S_pn_O(k1,1:dim(1)*dim(2));
            D1=D(k1,k1);
         else
            D1=D;
            SS=S_pn_O;
         end
         clear S_pn_O;
    else 
    Out{g}=[];
    Smpl{g}=[];
    h=Id_r{1,g};
    S_pn_O=zeros(prt(g),dim(1)*dim(2));
    disp(['Reading: # ',num2str(prt(g)),' images of matfile...']); pause(2);
    for i=1:prt(g)
        path=L(h(i)).name;
        load(path);
        S_pn_O(i,1:dim(1)*dim(2))=RN;
    end
%       
    disp('Correlation Computation ...');
    D1=1-cross_corr(S_pn_O');
    SS=S_pn_O;
    clear S_pn_O;
    clear CL_O;
    CL_O(1,1:numel(h))=CL(h,1);
    end
    [C,~,T_S_pn,S_pn_O,DIST,Mark]=clsr(CL_O,f,flag,D1,h,dim,SS,DIST,g,q,omega,Mark,list,thr);
    
%Saving and appending the obtained clusters
     disp(['##############Saving: # ',num2str(numel(C)),' images...']);
     in=1;
     
     for i=z+1:z+numel(C)
         L(i).name=fullfile('C:\BUFFER_RNs',strcat(['Itr_',num2str(n),'_RN_',num2str(i)],'.mat'));
         RN=T_S_pn(in,1:dim(1)*dim(2));
         save(L(i).name,'RN');
         in=in+1;
     end
     clear T_S_pn;
     z=z+numel(C);
     
     CL_new{1,g}=C;
     CL_n_new(g)=numel(CL_new{1,g});%keep numel for each cluster
     d=d+1;
     clear D1 D SS;
     clear C;
end%end of for prt
end% end of function
