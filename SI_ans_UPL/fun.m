function testval = fun(XTRAIN, YTRAIN, XTEST, YTEST,k)
% this program performs multi classification by ANN (nprtool model)
% by given TEST and TRAIN
    net = patternnet(100); %net = feedforwardnet(10);
    net = train(net, XTRAIN', YTRAIN');
%     net.trainFcn
    yNet = net(XTEST');
    % find which output (of the three dummy variables) has the highest probability
    [~,classNet] = max(yNet',[],2);
% net
    % convert YTEST into a format that can be compared with classNet
    for i=1:length(YTEST)
        [~,classTest(i,1)] = find(YTEST(i,:));
    end
    %%binary form of classnet and classtest
    classTest_bin=zeros(numel(classTest),k);
    classNet_bin=zeros(numel(classNet),k); 
    for i=1:numel(classTest)
        classTest_bin(i,classTest(i))=1;
        classNet_bin(i,classNet(i))=1;
    end
 
l1=unique(classNet);
CL_G=cell(1,max(l1));
for i=1:numel(classNet)
    CL_G{1,classNet(i)}=sort([i;CL_G{1,classNet(i)}]);
end

l2=unique(classTest);
CL_T=cell(1,max(l2));
for i=1:numel(classTest)
    CL_T{1,classTest(i)}=sort([i;CL_T{1,classTest(i)}]);
end

[F,pr,re,ac,ARI,sp,fpr,N_R,PURITY]=clsr_eval(k,numel(classNet),CL_G,CL_T);
testval=[F,pr,re,ac,ARI,sp,fpr,N_R,PURITY]';
 close all;
end