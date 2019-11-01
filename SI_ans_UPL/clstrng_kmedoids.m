function [Medoids,clusvector]=clstrng_kmedoids(DIST,k)
%%Clustering 
%%kmedoid clusteringclsrng_kmedoids
Medoids=[];
sumdist=sum(DIST);
[Min Medoids(1)]=min(sumdist);%Min: the minimum distance and 
%Medoids(1): the index of minimum value
nimg=size(DIST,1);
for k=2:k
   notselected=setdiff([1:nimg],Medoids);% the index of observation which has not been selected yet
   Cj=zeros(nimg,1);
   for i=notselected             
      for j=notselected(find(notselected~=i))
     % for j=notselected
         Dj=min( DIST(j,Medoids) );
         dij=DIST(j,i);
         Cj(i)=Cj(i)+max([Dj-dij 0]);
      end
   end
   [Max Medoids(k)]=max(Cj); %selected ones have score zero 
end                          %(no problem: not selected ones have always positive score (i==j))

%SWAP
notselected=setdiff([1:nimg],Medoids);
ns=nimg-k;  %=length(notselected);

minT=-1;
T=zeros(k,ns);
iter=0;
% sumD=[];
while (minT<0 & iter<=20)
   
for i=Medoids 
   for h=notselected
      Cjih=0;
      for j=union(notselected,i)    %All the notselected objects IF the swap is carried out+the gain that the newly selected object has
         Dj=min( DIST(j,Medoids) );
         dij=DIST(j,i);
         dhj=DIST(j,h);
         if Dj==dij
            Ej=min( DIST(j,Medoids(find(Medoids~=i)) ));
            if dhj<Ej
               Cjih=Cjih + dhj-dij;
            else 
               Cjih=Cjih + Ej-Dj;
            end
         elseif Dj>dhj
            Cjih=Cjih + dhj-Dj;
         end
      end
      if Medoids(1)==Medoids(2)
          Medoids=[];
          clusvector=[];
          return;
      end
      T(find(Medoids==i),find(notselected==h))=Cjih;
   end
end
[minT,Ind]=min(T(:));
if minT<0
   colh=ceil(Ind/k);
   rowi=Ind-(colh-1)*k;
   i=Medoids(rowi);
   Medoids(rowi)=notselected(colh);
   notselected(colh)=i;
end
iter=iter+1;
% sumiter=0;
% 
% for j=notselected
%    sumiter =sumiter+min( DIST(j,Medoids) );
% end

% sumD=[sumD sumiter];
end

%figure(1);
%plot(sumD);


%Information about the clustering
%we have DIST, Medoids

%clusvector 
clusvector=zeros(nimg,1);

for i=Medoids
   clusvector(i,1)=find(Medoids==i);
end
for j=notselected
   [Dj,Ind]=min( DIST(j,Medoids) );
   clusvector(j,1)=Ind;
end