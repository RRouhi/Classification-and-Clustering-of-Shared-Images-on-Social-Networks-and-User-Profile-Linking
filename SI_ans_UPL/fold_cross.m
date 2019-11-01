function [EVAL]=fold_cross(Dis_cor,img_usr,k,T_binQ)
% in this program, the indices for cross validation by 10-fold method is
% provided, the data is divided into 10 folds, one of which is selected for test
% the other ones are selected to train classifier.
% in test fold equal number of images from each class(smartphone) is obtained to have
% equal condition to evaluate sensitivity and specificity

folds=10;%10_fold
nimg=size(Dis_cor,1);
tr_img=img_usr-floor(img_usr./folds);%the number of images from each smartphones in every test fold
vali=zeros(folds,9);
 Te_inds=img_usr-tr_img;
for i=1:folds %for each fold determine test and train data
    TEST_inds=zeros(nimg,1);
    Test_ind_bin=zeros(nimg,1);
    inds=1;
    s=0;
    for id=1:k
       TEST_inds(Te_inds(id)*(i-1)+s+1:s+1+Te_inds(id)*(i)-1,1)=1;
       s=s+tr_img(id)+Te_inds(id);
    end
    % creat Test and Train Databases XTRAIN, YTRAIN, XTEST, YTEST
    Test_ind_bin=TEST_inds;
    XTEST=Dis_cor((Test_ind_bin==1),:);
    YTEST_bin=T_binQ((Test_ind_bin==1),:);
    % train
    XTRAIN=Dis_cor((Test_ind_bin==0),:);
    YTRAIN_bin=T_binQ((Test_ind_bin==0),:);
    testval = fun(XTRAIN, YTRAIN_bin, XTEST, YTEST_bin,k);
    vali(i,:)=testval;
end
% compute mean of sensitivity in 10 folds cross validation
SUM=sum(vali);
EVAL=SUM/folds;
end %end of function
