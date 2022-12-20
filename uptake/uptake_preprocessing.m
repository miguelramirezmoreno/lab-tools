%Uptake Quantifier v0.1, work in progress.


%This script generate projections from .tif files extracted from .lei
%packages.

clc;
clear variables;
close all;

%% 0. Settings to start the script

settings = inputdlg({'Enter total number of channels','Enter channel with borders', 'Enter channel to analyze'},'Input',1,{'3','1','3'});

n_channel = str2double(settings(1));
borderchannel = str2double(settings(2));
tauchannel = str2double(settings(3));

%% 1. Select the folder with the images to analyze and create folders

currentdir = pwd;
addpath(pwd);
filedir = uigetdir();

if exist([filedir, '/cell_borders'],'dir') == 0
    mkdir(filedir, '/cell_borders');
end
border_dir = [filedir, '/cell_borders'];


if exist([filedir, '/avg_apical'],'dir') == 0
    mkdir(filedir, '/avg_apical');
end
apical_dir = [filedir, '/avg_apical'];

if exist([filedir, '/avg_basal'],'dir') == 0
    mkdir(filedir, '/avg_basal');
end
basal_dir = [filedir, '/avg_basal'];


if exist([filedir, '/ecad_apical'],'dir') == 0
    mkdir(filedir, '/ecad_apical');
end
ecadapical_dir = [filedir, '/ecad_apical'];

if exist([filedir, '/ecad_basal'],'dir') == 0
    mkdir(filedir, '/ecad_basal');
end
ecadbasal_dir = [filedir, '/ecad_basal'];


if exist([filedir, '/original_files'],'dir') == 0
    mkdir(filedir, '/original_files');
end
ori_dir = [filedir,'/original_files'];

%% 2. Counting how many files to analyze

cd(filedir);
files = dir('*.tif');
numberfiles= numel(files);

%% 3. First loop: stack by stack

for i=1:numberfiles
    currentfile= [num2str(i),'.tif'];
    % the following line recalls bfopen from the bioformats package, which
    % allows us to operate with image stacks
    stack = bfopen(currentfile);
    % the files as it is now contains a lot of stuff like metadata that we
    % do not need, we recall the first page which contains the actual
    % slices with the next line.
    disc= stack{1,1};
    % we now calculate how many steps the stack has.
    disc_steps= ((size(disc, 1))/n_channel);
    %we now generate the variables that will contain the data for the
    %projections
    GFP_average = zeros(size(disc{1,1},1),size(disc{1,1},2));
    GFP_max = zeros(size(GFP{1,1},1),size(GFP{1,1},2));

    Ecad_average = zeros(size(GFP{1,1},1),size(GFP{1,1},2));
    GFP_max = zeros(size(GFP{1,1},1),size(GFP{1,1},2));
    %% The second loop begins, to generate data for projections slice by slice
    for j= 1:GFP_steps
        GFP_average = GFP_average + double(GFP{j});
        GFP_max = max(GFP_max, double(GFP{j}));
    end
    
    GFP_average = uint16(GFP_average/GFP_steps);
    avg_thr= graythresh((im2double(GFP_average)));
    GFP_max= imadjust(uint16(GFP_max));
    max_thr= graythresh((im2double(GFP_max)));
    thr_file = [avg_thr, max_thr];
    thr_values = [thr_values; thr_file];
    cd(avg_dir);
    imwrite(GFP_average,[num2str(i), '.tif']);
    cd(max_dir);
    imwrite(GFP_max,[num2str(i), '.tif']);

    summary_thr(i,:)= [i, avg_thr,max_thr];
%      imshow(imbinarize(GFP_average))
    cd(filedir);
%     movefile([num2str(i), '.tif'], ori_dir);

end
