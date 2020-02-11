% clear;
% c=100;
% img_user=[0,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,500];%Native_remove
% img_user=[0,205,204,350,132,178,209,227-7,204,150,224,204,0];
K=11;%# of phones/users
users=K;
NOUT=100;
nout=100;
Da='NA';
img_user=[0,202-2,200,333,129,178,206,227,201,150,223,203,nout];%Native_remove
% % img_user=[0,202,200,237,224,333-8,129,216,166,217,178,207,216,170,206,227,234,180,201,256,157,249,163,208,311,284,150,254,265,223,271,208,236,153,203,154,nout];
% img_user=[0,237,224,216,166,217,207,216,170,234,180,256,157,249,163,208,311-6,284,254,265,271,208,236,153,154,nout];
MinPts=20;
eps=0.995;
start_path = fullfile('C:\PhD\Scripts\Dataset_Vision_11\11_phones');%from where the program reads the images
[list]=read_images(img_user,start_path);
svpath='C:\PhD\Scripts\Final_Important_Scripts\Outliers\Results\11_phone\';
mkdir('C:\BUFFER_RNs');
delete('C:\BUFFER_RNs*');
dim=[1024,1024];%resize
img=sum(img_user(1:K));
N=img+nout;
nimg=N;
Mark=zeros(N);
q=1000;%size of batch
ind_out=randsample(sum(img_user(1:K))+1:sum(img_user),nout);
tot=[1:sum(img_user(1:K)),ind_out];
%%
op=1; %to determine whether op=1 DBSCAN or op=0 DKNN
f=1; flag=1; 
thr=1;
thr1=0.004;
omega=0.17; 
pm=88; % for DKNN
% for tt=1:1
tt=1;
tic
DIST=zeros(nimg);
t1=N;
CL_n=[];
CL_new=[];
CL_new1=[];
%%Read images
%%
[CL_new1,CL_n_new,DIST,L,Mark,Out,Smpl]=hyb_clsr(list,f,flag,N,q,CL_new,CL_n,DIST,dim,omega,Mark,thr1,MinPts,eps,op,pm,tot);
                                    
f=1; flag=1; 
%  % Find fine & coarse clusters
 CL=CL_new1;
 [nrows,~] = cellfun(@size,CL);
 CL_n=num2cell(nrows); 
 me_cl(1:numel(CL),1)=bsxfun(@rdivide,nrows(1:numel(CL)),nimg/numel(CL)); 
% Coarse and Fine Clusters
 CL_gr={};
 CL_fine={};
 SP_fine=[];
 SP_G=[];
 CL_G={};
 d=1;
 g=1;
% % % % Coarse 
[rg,cc]=find(me_cl>=thr);
n_gr=sum(cc);
CL_gr(1:n_gr,1)=CL(rg);
for i=1:numel(rg)
    Lcoarse(i).name=L(rg(i)).name;
end

% % % % % Fine
rf=setdiff(1:numel(CL),rg);
n_fine=numel(CL)-n_gr;
CL_fine(1:n_fine,1)=CL(rf');
for i=1:numel(rf)
    Lfine(i).name=L(rf(i)).name;
end
[CLfine_n,~]=cellfun(@size,CL_fine);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [F(tt),pr(tt),re(tt),ac(tt),ARI(tt),sp(tt),fpr(tt),N_R(tt),Purity(tt)]=clsr_eval_new(K-1,N,CL_gr',img_user(2:K+1));
[F(tt),pr(tt),re(tt),ac(tt),ARI(tt),sp(tt),fpr(tt),N_R(tt),Purity(tt)]=clsr_eval(K,sum(img_user(1:K+1)),CL_gr',img_user(2:K+1));
% % % % [F(R1,R2),pr(R1,R2),re(R1,R2),ac(R1,R2),ARI(R1,R2),sp(R1,R2),fpr(R1,R2),N_R(R1,R2),Purity(R1,R2)]=clsr_eval_new(K-1,sum(img_user(1:K)),CL_gr',img_user(2:K));
% % % 
% me_cl=[];
% CL_fine_n=[];
% delete('G:\BUFFER_RNs\*')
T=toc;
% end %END of repeatation

F_t=mean(F);
PR_t=mean(pr);
RE_t=mean(re);
AC_t=mean(ac);
ARI_t=mean(ARI);
SP_t=mean(sp);
FP_t=mean(fpr);
N_R_t=mean(N_R);
Purity_t=mean(Purity);
Time=mean(T);

All_Results(1:10)=[F_t,PR_t,RE_t,AC_t,ARI_t,SP_t,FP_t,N_R_t,Time,Purity_t];

% Indices of data 
R=cell2mat(CL');
Normal=cell2mat(CL_gr);
Uncls=setdiff(R,Normal);%fine clusters
Outliers=sort(cell2mat(Out'));%output of DBSCAN setdiff(1:N,R)'
samples=sort(cell2mat(Smpl'));
% evaluation on outliers
idx=zeros(N,1);
idx(Outliers(Outliers<=sum(img_user(1:K))))=1;
O=Outliers>sum(img_user(1:K));
idx(sum(img_user(1:K))+1:sum(img_user(1:K))+sum(O))=1;
T=zeros(N,1);
T(1:sum(img_user(1:K)))=0;
T(sum(img_user(1:K))+1:nimg)=1;

save([svpath,Da,'\Results1_',Da,'_',num2str(nout),'.mat'],'All_Results');
save([svpath,Da,'\Unclustered1_',Da,'_',num2str(nout),'.mat'],'Uncls');
save([svpath,Da,'\Outliers1_',Da,'_',num2str(nout),'.mat'],'Outliers');
save([svpath,Da,'\Normal1_',Da,'_',num2str(nout),'.mat'],'Normal');
% % clearvars -except img_user list NOUT nout RE R1 R2 Da eval_O_N F pr re ac ARI sp fpr N_R Purity MinPts eps K img
% %    end 

