% This scripts extracts residual noises from the gray scale images and save them in .mat format
% All the extracted RNs are saved in Portrait view

clear;
clc;

img_user=[0,205,204,237,227,350,132,217,168,217,178,207,216,171,209,227,235,188,204,259,159,253,163,210,312,287,150,254,266,224,271,216,236,155,204,154];
k=35;
% img_user=[0,205,204,350,132,178,209,227,204,150,224,204];%i
% users=11;
nimg=sum(img_user);

dim=[1024,1024]; % Resolution for resizing RNs
workspace;  % Make sure the workspace panel is showing.  listOfFolderNames,thisFolder = listOfFolderNames{k};
%numberOfImageFiles = length(baseFileNames); fullFileName
format long g;
format compact;
% Define a starting folder.
start_path = fullfile('G:\Vision_Dataset\Vision_dataset\natFBH');
% Ask user to confirm or change.
topLevelFolder = uigetdir(start_path);
if topLevelFolder == 0
	return;
end
% Get list of all subfolders.
allSubFolders = genpath(topLevelFolder);
% Parse into a cell array.
remain = allSubFolders;
listOfFolderNames = {};
while true
	[singleSubFolder, remain] = strtok(remain, ';');
	if isempty(singleSubFolder)
		break;
	end
	listOfFolderNames = [listOfFolderNames singleSubFolder];
end
numberOfFolders = length(listOfFolderNames)

% Process all image files in those folders.
for k = 1 : numberOfFolders
	% Get this folder and print it out.
	thisFolder = listOfFolderNames{k};
	fprintf('Processing folder %s\n', thisFolder);
	
	% Get PNG files.
	filePattern = sprintf('%s/*.png', thisFolder);
	baseFileNames = dir(filePattern);
	% Add on TIF files.
	filePattern = sprintf('%s/*.tif', thisFolder);
	baseFileNames = [baseFileNames; dir(filePattern)];
	% Add on JPG files.
	filePattern = sprintf('%s/*.jpg', thisFolder);
	baseFileNames = [baseFileNames; dir(filePattern)];
    
	numberOfImageFiles = length(baseFileNames);
	% Now we have a list of all files in this folder.
	
	if numberOfImageFiles >= 1
		% Go through all those image files.
        listimg=struct([]);
        ind=1; %for writing images in listimg and folder
        flag=1;
%         for h=1:numel(img_user)
		    for f=1:img_user(k)
			    fullFileName = fullfile(thisFolder, baseFileNames(f).name);
			    fprintf('     Processing image file %s\n', fullFileName);
                listimg(ind,1).name=fullFileName;
                listimg(ind,1).folder=thisFolder;
                %RN extraction
                [listimg(ind,1).RN]=rn_extraction(listimg(ind,1).name);
                %% creating the address to save RN for each image
                st=baseFileNames(f).name;
                id=regexp(st,'\d');
                clear snew;
                for s=1:numel(id)
                    snew(s)=st(id(s));
                end
                imgind=[char(snew)];
                listimg(ind,1).indx=imgind;
                thisFolder=listimg(ind).folder;
                imgind=listimg(ind).indx;
                path=fullfile(thisFolder,imgind);
                r=listimg(ind);%whole inf of residual noise
                r=imresize(r.RN,dim);
                ave(path,'r');
                ind=ind+1; 
           end
%             clear listimg;
%             clear r;
%          end
            clear listimg;
            clear r;

	else
		fprintf('     Folder %s has no image files in it.\n', thisFolder);
    end
end

