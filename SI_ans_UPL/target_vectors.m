function[T,T_bin]=target_vectors(N,img_user,k)
i=1;
j=0;
T=zeros(N,1);
T_bin=zeros(N,k);
while i<N
     T(i:i+img_user(j+1)-1)=j;
     i=i+img_user(j+1);
     j=j+1;
end
for i=1:N
%making binary format of target
    T_bin(i,T(i))=1;
end
end
