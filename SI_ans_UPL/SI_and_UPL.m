% % % clc;
tic
k=18;%# of phones/users
dim=[1024,1024];%resize
c=50;
img_user=[0,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c,c];
%List of images from the first SN
[list1]=read_images(img_user);
%List of images from the second SN
[list2]=read_images(img_user);
N=sum(img_user);
d=20;%parameter for Shared Nearest Neighbour
[A]=SNN(DIST,d,'correlation');
figure;imshow(A);
[~,clus]=clstrng_kmedoids(normalize(d-A),k);

%Target vector
[T,T_bin]=target_vectors(N,img_user,k);
[newL] = bestMap(T,clus);
CL_gr=cell(1,k);
CL_T=cell(1,k);
for i=1:N
    CL_gr{1,newL(i)}=[CL_gr{1,newL(i)};i];
    CL_T{1,T(i)}=[CL_T{1,T(i)};i];
end

% % % %% Evaluation
[F,pr,re,ac,ARI,sp,fpr,N_R,Purity]=clsr_eval(k,N,CL_gr,CL_T)
Results=[F,pr,re,ac,ARI,sp,fpr,N_R,Purity];
% Pattern noise extraction
[SPN]=pn_exr(CL_gr,list1,dim);
[Dis_cor]=dis_pn(SPN,list2,N,dim,k);
%% Matching part by multiple classification
REP=5; %number of times to repeat 10-fold cross validation
for rep=1:REP %times of repeating 10_fold in different shuffling
%shuffle
    t=0;
    s=0;
    shuf_D=zeros(N,k);
    for i=1:k %for each class of phones
        c=img_user(i+1);
        shuf_ind=randperm(c,c);%generate shuffle indices from 1 t0 50
        s=s+img_user(i);
        shuf_ind=shuf_ind+s;% convert previous indices to the related smartphones
        shuf_ind=shuf_ind';
        % creat new matrix to put shuffled data
        shuf_D(t+1:t+c,:)=Dis_cor(shuf_ind,:);
        t=t+c;
    end
    rep
% 10_fold cross validation
    [EVAL]=fold_cross(shuf_D,img_user(2:k+1),k,T_bin);
    EVALUATION(rep,1:9)=EVAL;
end
