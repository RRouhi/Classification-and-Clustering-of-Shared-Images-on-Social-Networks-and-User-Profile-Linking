%This script provides a Sensor Pattern Noise (SPN) based Image clustering
clc;
clear;
mkdir('C:\BUFFER_RN_G');
mkdir('C:\BUFFER_RN_F');
delete('C:\BUFFER_RN_G\*');
delete('C:\BUFFER_RN_F\*');
k=11;%# of phones/users
users=k;
% dim=[960,720];%low resolution Facebook
dim=[1024,1024];
% img_user=[0,205,204,350,132,178,209,227-7,204,150,224,204,0];
img_user=[0,202-2,200,333,129,178,206,227,201,150,223,203];%Native_remove
% img_user=[0,202-2,200,333,129,178,206,227,201,150,223,203];%*****whatsapp_remove
% img_user=[0,202-2,200,333,129,178,206,227,201,150,223,203];%Fecebook_High_remove
% img_user=[0,124,157,296,68,99,164,153,176,82,188,120];%Facebook_low_remove
% img_user=[0,188,191,219,132,176,197,224,144,150,176,203];
% img_user=[0,237,227,217,168,217,207,216,171,235,188,259,159,253,163,210,312,287,254,266,271,216,236,155,154];
% img_user=[0,205,204,237,227,350,132,217,168,217,178,207,216,171,209,227,235,188,204,259,159,253,163,210,312,287,150,254,266,224,271,216,236,155,204,154];
% % % % img_user=[0,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c];
%35
% img_user=[0,202,200,237,224,333-8,129,216,166,217,178,207,216,170,206,227,234,180,201,256,157,249,163,208,311,284,150,254,265,223,271,208,236,153,203,154];
%24
% img_user=[0,237,224,216,166,217,207,216,170,234,180,256,157,249,163,208,311-6,284,254,265,271,208,236,153,154];
% c=100;
% img_user=[0,c,c,c,c,c,c,c,c,c,c];
% img_user=[0,c,c,c,c,c,c,c,c,c,c,c,0];
% % img_user=[0,50,60,70,80,90,100,110,120,130,140,150];
% img_user=[0,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c];
% img_user=[0,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c];
% c=35;
% img_user=[0,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c];
nimg=sum(img_user);
N=nimg;
DIST=zeros(N);
Mark=zeros(N);
C_T=0;
I_O=0;
q=1000;%sizeof batch
start_path = fullfile('I:\Vision_dataset');%from where the program reads the images
[list]=read_images(img_user,start_path);
%
overall_time=tic;
for tt=1:1
% DIST=zeros(nimg);
t1=N;
CL_n=[];
CL_new=[];
CL_new1=[];
%%Read images
f=1; flag=1; 
omega=0.08;
thr=1;  
thr1=0.004; %With constant threshold (Native=0.09) (WhatsApp=0.05) (FBH=0.03) (FBL=0.03?)
thr2=0.004;%
C=0;
I_O=0;
%%
[CL_new1,CL_n_new,DIST,Mark,L,C_T,I_O]=hyb_clsr(f,flag,N,q,CL_new,CL_n,DIST,Mark,dim,thr1,C_T,I_O,list,omega);
                                           

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

%%
[F2(tt),pr2(tt),re2(tt),ac2(tt),ARI2(tt),sp2(tt),fpr2(tt),N_R2(tt),Purity_2(tt)]=clsr_eval(k,N,CL_gr',img_user(2:k+1));
me_cl=[];
CL_fine_n=[];
delete('G:\BUFFER_RNs\*')
end %END of repeatation

T=toc(overall_time);
F_t=mean(F2);
PR_t=mean(pr2);
RE_t=mean(re2);
AC_t=mean(ac2);
ARI_t=mean(ARI2);
SP_t=mean(sp2);
FP_t=mean(fpr2);
N_R_t=mean(N_R2);
Purity_t=mean(Purity_2);

All_Results(1:9)=[F_t,PR_t,RE_t,AC_t,ARI_t,SP_t,FP_t,N_R_t,Purity_t]

 cell2mat(CL_fine)