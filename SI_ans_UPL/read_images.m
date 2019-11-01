function [listimg]=read_images(img_user)
%this program extract the directory address of all images to have their
%residual noise
% Start with a folder and get a list of all subfolders.
% Finds and prints names of all PNG, JPG, and TIF images in 
% that folder and all of its subfolders.
% % Similar to imageSet() function in the Computer Vision System Toolbox: http://www.mathworks.com/help/vision/ref/imageset-class.html
% clc;    % Clear the command window.
% workspace;  % Make sure the workspace panel is showing.  listOfFolderNames,thisFolder = listOfFolderNames{k};
%numberOfImageFiles = length(baseFileNames); fullFileName
format long g;
format compact;
listimg=struct([]);
ind=1;
% Define a starting folder.
start_path = fullfile('G:\Total_Data');
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
	filePattern = sprintf('%s/*.mat', thisFolder);
	baseFileNames = [baseFileNames; dir(filePattern)];
    
	numberOfImageFiles = length(baseFileNames);
	% Now we have a list of all files in this folder.
	
	if numberOfImageFiles >= 1
		% Go through all those image files.
		for f = 1 : img_user(k)
			fullFileName = fullfile(thisFolder, baseFileNames(f).name);
			fprintf('     Processing image file %s\n', fullFileName);
            listimg(ind,1).name=fullFileName;
            listimg(ind,1).folder=thisFolder;
            %% creating the address to save RN for each image
              st=baseFileNames(f).name;
              id=regexp(st,'\d');
              clear snew;
             for s=1:numel(id)
               snew(s)=st(id(s));
             end
             imgind=[char(snew)];
             listimg(ind,1).indx=imgind;
             ind
             ind=ind+1;
		end
	else
		fprintf('     Folder %s has no image files in it.\n', thisFolder);
	end
end
end
