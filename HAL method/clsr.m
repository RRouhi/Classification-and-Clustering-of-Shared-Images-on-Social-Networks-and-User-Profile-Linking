function [CL,CL_n,S_pn,S_pn1,DIST,Mark,C_T,I_O]=clsr(CL,f,flag,DIS,h,dim,S_pn,DIST,Mark,g,q,thr,C_T,I_O,list,omega)   
    
  %Fine Clustering 
N=size(DIS,1);
DIS_norm=normalize(DIS);
m = mcl(DIS_norm);
Label=zeros(N,1);
L=Label;
L(Label==0)=-1;
t2=N;
t1=t2+1;
IGN=[];
ign=1;
% Temp_I=50;
if flag 
    PN=S_pn;
end

for i=1:N
     [rr,~]=find(m(i,:)~=0);
     if (min(m(i,:))==0 && max(m(i,:))==1) || (sum(rr)<=1)
        IGN(ign)=i;
        ign=ign+1;
    end
end
chk=setdiff(1:N,IGN);
ind=1:N;

while ~(t1==t2)
      for i=chk
          if(L(ind(i))==-1)%if the object does not have label
             [v,~] = sort(m(ind(i),:));
             ind_min=find(v(N-1)==m(ind(i),:));% I mean minimum distance which is the maximum in m matrix
             low=setdiff(ind_min,ind(i));%remove itself%%%???????????????
             low=setdiff(low,IGN);
             for j=1:length(low)
                 ms=low(j);
                 if flag %for the first time only
                           CL{1,ind(i)}=[CL{1,ms};CL{1,ind(i)}]; 
                           L(ind(i))=0;
                           L(ms)=0;
                 else % for the next times
                        if ~isempty(CL{1,ms})&& ~isempty(CL{1,ind(i)})
%                             [mrg,DIST,C_T,I_O]=test_Mabi(ind(i),ms,DIS,CL{1,ms},CL{1,ind(i)},thr,DIST,C_T,I_O);% merg two clusters (Changes)
%                                 [mrg]=test_K_medoids(CL{1,ms},CL{1,ind(i)},DIST);%K_medoids
                                [mrg,DIST,Mark,C_T,I_O]=test(ind(i),ms,DIS,CL{1,ms},CL{1,ind(i)},DIST,Mark,list,thr,dim,C_T,I_O,omega);
%                                   [mrg,DIST]=test7(ind(i),ms,DIS,CL{1,ms},CL{1,ind(i)},thr,DIST);
                            if mrg
                                if  L(ms)==0
                                    CL{1,ms}=[CL{1,ms};CL{1,ind(i)}];
                                    CL{1,ind(i)}=[];
                                    CL_n{1,ms}=numel(CL{1,ms})+numel(CL{1,ind(i)});
                                    CL_n{1,ind(i)}=[];
                                    L(ind(i))=0;
                                    S_pn(ms,:)=(S_pn(ms,:)+S_pn(ind(i),:));
                                    S_pn(ind(i),:)=0;
                                else 
                                    CL{1,ind(i)}=[CL{1,ms};CL{1,ind(i)}];
                                    CL{1,ms}=[];
                                    CL_n{1,ind(i)}=numel(CL{1,ms})+numel(CL{1,ind(i)});
                                    CL_n{1,ms}=[];
                                    L(ind(i))=0;
                                    L(ms)=0;
                                    S_pn(ind(i),:)=(S_pn(ms,:)+S_pn(ind(i),:));
                                    S_pn(ms,:)=0;
                                end
                            end%new
                        else
                            L(ind(i))=0;
                            L(ms)=0;   
                        end
                 end%flag
             end%low
          end%L(i)==-1
           
      end%for chk
% %%remove repeated objects in cells of CL%it seems it is only for flag=1
clus=length(CL);
CL=cellfun(@unique,CL,'UniformOutput',false);
S_pn((cellfun('isempty',CL))',:)=0;
      for i=1:clus-1 %%%%take
          for j=i+1:clus  
              if intersect(CL{1,i},CL{1,j})
                 CL{1,i}=union(CL{1,i},CL{1,j});
                 CL{1,j}=[];
              end
          end
      end
% % updat CL
t1=length(CL);%old 
CLL=CL;
CL=CL(~cellfun('isempty',CL));%remove empty cells
[nCL,~] = cellfun(@size,CL);
CL_n=num2cell(nCL);

t2=length(CL);%new

clear PN;
if (flag==1 && f==0 && ~isempty(S_pn))
    b=~cellfun('isempty',CLL);
    if ~intersect(b,0)
       c=find(b==1);
       S_pn1(1:numel(c),:)=S_pn(c,:);
       clear S_pn;
       S_pn=S_pn1;
       clear S_pn1;
       %%Object_mat.S_fine=S_pn;
       clear PN_a PN;
       %%%%%%%%%%%%%%%%
    end
elseif (flag==1 && f==1 && ~isempty(S_pn))
      [S_pn]=pn_exr(CL,dim,S_pn,h,g,q);%(CL,dim,SP)
else
    S_pn(all(S_pn==0,2),:)=[];
    clear PN_a PN;
end
% % break the while sooner
if t1==t2
    break;
end
  T1=tic;
distance=1-cross_corr(S_pn');%compute distance
  C_T=toc(T1)+C_T;
% clear PN;%***********
Dist_norm=normalize(distance);
clear m;
m = mcl(Dist_norm);
N=length(m);
ind=1:N;%index of PNs

% % ignore rows with 0 and 1 in m, (they are more likely have been packed as normal) 
ign=1;
IGN=[];
for i=1:N
     [rr,~]=find(m(i,:)~=0);
     if (min(m(i,:))==0 && max(m(i,:))==1) || (sum(rr)<=2)  %The cluster has already gathered its members 
        IGN(ign)=i;
        ign=ign+1;
    end
end
chk=setdiff(1:N,IGN);
L=zeros(N,1)-1;
flag=0;
f=0;
DIS=distance;
end%while
CL_n=cell2mat(CL_n);
S_pn1=[];

