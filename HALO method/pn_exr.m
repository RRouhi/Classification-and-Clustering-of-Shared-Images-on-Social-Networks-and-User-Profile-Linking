%--------------------------------------------------------------
%This function obtain Pattern noises correspocding to each cluster
%--------------------------------------------------------------
function [S_pn]=pn_exr(CL,dim,SP,h,g,q)
  C=length(CL);
  [d,~] = cellfun(@size,CL);
  S_pn=zeros(C,dim(1)*dim(2));
% % % %   PN=zeros(C,dim(1)^2);
  for i=1:C
      clear indx;
      indx=CL{1,i};
%       S_pn(i,:)=sum(SP(indx-(g-1)*q,:));%when we do not select randomely
      if numel(indx)==1
         S_pn(i,:)=SP(ismember(h,indx),:);
      else
         S_pn(i,:)=sum(SP(ismember(h,indx),:));
      end
  end
% % % %   PN=bsxfun(@rdivide,S_pn,d');
end