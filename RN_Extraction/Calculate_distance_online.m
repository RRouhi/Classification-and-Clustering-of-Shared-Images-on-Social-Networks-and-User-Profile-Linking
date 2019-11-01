c=20;
img_user=[0,c,c,c,c,c,c,c,c,c,c,c];
[list]=read_images_2(img_user);
users=11;
k=11;% number of clusters in reference database
nimg=sum(img_user);
% % % % dim=[1024,1024];% the size reference images
DIST=zeros(nimg);
disp('calculating similarities(PEARSON CORR) among residual noises...');
for i=1:nimg
    path1=fullfile(list(i).folder,list(i).indx);
    path1=strcat(path1,'.mat');% load RNs
    clear r; % to be sure the last data is not accessible 
    load(path1);% select the directory of databse on the computer
%          OUT1=imresize(r.RN,dim);
    OUT1=r;
    for j=i+1:nimg
        path2=fullfile(list(j).folder,list(j).indx);
        path2=strcat(path2,'.mat');% load RNs
        clear r; % to be sure the last data is not accessible 
        load(path2);% select the directory of databse on the computer
%         OUT2=imresize(r.RN,dim);
        OUT2=r;
        a=1-prcorr2(OUT1,OUT2);
        b=1-prcorr2(OUT1,imrotate(OUT2,-180));
        if a<b
           DIST(i,j)=a;
        else
           DIST(i,j)=b;
        end
          DIST(j,i)=DIST(i,j);
          disp(['Calculating: DIST(',num2str(i),',',num2str(j),')']);
    end
end


