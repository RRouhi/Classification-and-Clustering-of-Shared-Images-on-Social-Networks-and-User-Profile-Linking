function [CL_new,CL_n_new,DIST,L,Mark,Out1,Smpl1]=hyb_clsr(list,f,flag,N,q,C,CL_n_new,DIST,dim,omega,Mark,thr,MinPts,eps,op,pm,tot) 
         
f1=0;
f2=N;
b=1;
PP(b)=0;
b=b+1;
prt=q+1;%for the first time to run
n=1;
L=[];
while ~(f1==f2)  %&& (sum(prt)>=q)
    if n>=2
        q=2000;
    end
       [prt,CL,DIST,L,Mark,Out,Smpl]=dis_batch(list,N,q,C',f,flag,DIST,dim,q,omega,n,L,Mark,thr,MinPts,eps,op,pm,tot);%D_sp is a cell to keep distances for
       CL_new={};
       d=1;
       for i=1:numel(CL)
          for j=1:numel(CL{1,i})
              CL_new{1,d}=cell2mat(CL{1,i}(1,j));%the new cluster%%%%??????????
              CL_n_new(d)=numel(CL_new{1,d});%keep numel for each cluster
              d=d+1;
          end
       end
       N=numel(CL_new);
       PP(b)=numel(prt);
       f1=PP(b);%f1=PP(b-1)
       f2=PP(b-1);%f2=PP(b-2)
       b=b+1;
       if flag
          Out1=Out;
          Smpl1=Smpl;
       end
       f=0;
       flag=0;
       C=CL_new;
%        pause(5);
       n=n+1;
end%end while
end%function