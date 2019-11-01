
function [rn]=rn_extraction(imgname)
%this program receives the address of image and extracts residual noise
   IMG=imread(imgname);         
   IMG=im2double(IMG);
   size_IMG=size(IMG);
   if size_IMG(1) < size_IMG(2)
     %It rotates the image 90 degrees
     IMG = imrotate(IMG,-90);
   end
%convert image to grayscale version
   if numel(size_IMG)==3
    IMG=rgb2gray(IMG); 
   else
      IMG=IMG;
   end    
      tic;
      rn= BM3D(1,IMG,4);
      rn = IMG - rn;
      toc;
end
