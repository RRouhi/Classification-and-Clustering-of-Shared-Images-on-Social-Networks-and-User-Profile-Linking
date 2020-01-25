%calculates distances among all the images in the dataset based on
%partitioning

function [prt,CL_new,DIST,Mark,L,C_T,I_O]=dis_batch(N,q,CL,f,flag,DIST,Mark,dim,prt,thr,n,L,C_T,I_O,list,omega)
d=1;
Id_r={};%to keep randomely the indices in the partitions
% if flag
%     tot=setdiff(1:N,y);
%     N=numel(tot);
% else 
    tot=1:N;
% end
T1=tic;
CL_new={};%to keep all the obtained clusters from all the batches
if flag && isempty(CL)
    for i=1:floor(N/q)
        Id_r{1,i}=randsample(tot,q);%sort
        tot=setdiff(tot,Id_r{1,i});
    end
else
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
I_O=toc(T1)+I_O;
for g=1:numel(prt)
    tic;
    if (f && isempty(CL))
         S_pn_O=zeros(prt(g),dim(1)*dim(2));
         h=Id_r{1,g}; 
         h=h';
            T2=tic;
         for i=1:prt(g)
             path=fullfile(list(h(i)).folder,list(h(i)).indx);
             clear r;
             load(path);
             disp(['Reading: image(',num2str(h(i)),' out of ',num2str(sum(prt)),'...)']);
%              cl_r=WienerInDFT(r,std2(r));
%              S_pn_O(i,:)=cl_r(:)';
             S_pn_O(i,:)=r(:)';
         end
            I_O=toc(T2)+I_O;
         disp(['Reading: Part(',num2str(g),' out of ',num2str(numel(prt)),'...)']);
         clear D
         disp('Distance Calculation ...');
            T3=tic;
         D=1-cross_corr(S_pn_O');
            C_T=toc(T3)+C_T;
         if flag
            DIST(h,h)=D;
            Mark(h,h)=1;
         end
         CL_O=num2cell(h);%the old cluster%for the first time only
         CL_O=CL_O';
    else  
        h=Id_r{1,g};
        S_pn_O=zeros(prt(g),dim(1)*dim(2));
        disp(['Reading: # ',num2str(prt(g)),' images of matfile...']); pause(2);
            T4=tic;
        for i=1:prt(g)
            path=L(h(i)).name;
            load(path);
            S_pn_O(i,1:dim(1)*dim(2))=RN;
        end
            I_O=I_O+toc(T4);
%       
        disp('Distance Calculation ...');
           T5=tic;
        D=1-cross_corr(S_pn_O');
           C_T=C_T+toc(T5);
        clear CL_O;
        CL_O(1,1:numel(h))=CL(h,1);
    end
    [C,~,T_S_pn,S_pn_O,DIST,Mark,C_T,I_O]=clsr(CL_O,f,flag,D,h,dim,S_pn_O,DIST,Mark,g,q,thr,C_T,I_O,list,omega);
    
%Saving and appending the obtained clusters
     disp(['##############Saving: # ',num2str(numel(C)),' images...']);
     in=1;
        T6=tic;
     for i=z+1:z+numel(C)
         L(i).name=fullfile('/media/csudeeplearning/ra.rouhi@gmail.com/BUFFER_RNs1/',strcat(['Itr_',num2str(n),'_RN_',num2str(i)],'.mat'));
         RN=T_S_pn(in,1:dim(1)*dim(2));
         save(L(i).name,'RN');
         in=in+1;
     end
        I_O=toc(T6)+I_O;
     clear T_S_pn;
     z=z+numel(C);
     
     CL_new{1,g}=C;
     CL_n_new(g)=numel(CL_new{1,g});%keep numel for each cluster
     d=d+1;
     clear D;
     clear C;
end%end of for prt
end% end of function
