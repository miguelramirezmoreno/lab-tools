clc;
clear variables;
close all;

currentdir = pwd;
addpath(pwd);
main = uigetdir();



pouch_dir = [main, '/mask_pouch'];
cherry_dir = [main, '/mask_cherry'];
signal_dir = [main, '/avg_basal'];

if exist([main, '/dcp1_binary'],'dir') == 0
    mkdir(main, '/dcp1_binary');
end
binary_dir = [main, '/dcp1_binary'];


if exist([main, '/dcp1_antbinary'],'dir') == 0
    mkdir(main, '/dcp1_antbinary');
end
ant_dir = [main, 'dcp1_antbinary'];

if exist([main, '/dcp1_posbinary'],'dir') == 0
    mkdir(main, '/dcp1_postbinary');
end
post_dir = [main, 'dcp1_posbinary'];

cd(signal_dir);
files = dir('*.tif');
numberfiles= numel(files);
summary =  zeros(numberfiles, 12);
resolution = 1.76;
conversion = (1 /(resolution^2));



% conversorarea = 
for i=1:numberfiles
    summary(i,1)= i;
    
    currentfile= [num2str(i),'.tif'];
    disc = bfopen(currentfile);
    disc_image= disc{1,1};
    dcp1_signal= disc_image{3};
    dcp1_signal2 = imgaussfilt(dcp1_signal,1);
    background = imopen(dcp1_signal2, offsetstrel('ball', 5, 5));
    dcp1_signal2 = imsubtract(dcp1_signal2, background);
    dcp1bw= imbinarize(dcp1_signal2);
    dcp1bw = bwareaopen(dcp1bw, 5);

    image = figure;
    imshowpair(dcp1_signal, dcp1bw);
    hold on;
    cd(binary_dir);
    image_name = [num2str(i),'_dcp1_signal.tif'];
    print(image, '-dtiff', '-r150', image_name);
    close all
    

    cd(pouch_dir);
    mask_pouch= imbinarize(imread(currentfile));
    pouch_region = regionprops(mask_pouch);
    summary(i,2)= conversion * pouch_region.Area;

    cd(cherry_dir);
    mask_cherry= imbinarize(imread(currentfile));
    cherry_region = regionprops(mask_cherry);
    summary(i,4) = conversion * cherry_region.Area;
    summary(i,3) =  summary(i,2) - summary(i,4);

    pouchbw =  dcp1bw;
    pouchbw(mask_pouch==0) = 0;

%     imshowpair(pouchbw, mask_cherry)

    bwant = pouchbw;
    bwant(mask_cherry==1) = 0;
    dcp1_ant = regionprops(bwant);
    summary(i, 5) = size(dcp1_ant, 1);
    summary(i, 7) = conversion * sum([dcp1_ant.Area]);

    bwpos = pouchbw;
    bwpos(mask_cherry==0) = 0;
    dcp1_pos = regionprops(bwpos);
    summary(i, 6) = size(dcp1_pos, 1);
    summary(i, 8) = conversion * sum([dcp1_pos.Area]);

    summary(i,9) =  summary(i,5) / summary(i,3);
    summary(i,10) =  summary(i,6) / summary(i,4);
    summary(i,11) =  summary(i,7) / summary(i,3);
    summary(i,12) =  summary(i,8) / summary(i,4);
    cd(signal_dir);

end

cd(main);
results = array2table(summary);
results.Properties.VariableNames = {'Disc', 'Area pouch', 'Anterior Pouch' 'Posterior Pouch', 'Anterior Cells',...
    'Posterior Cells', 'Anterior death area', 'Posterior death area', 'Anterior index', 'Posterior Index',...
    '% Anterior apoptotic area', '% Posterior apoptotic area'};
writetable(results,'results.csv');


close all;
clear variables;
clc;