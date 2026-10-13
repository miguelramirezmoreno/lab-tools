clc;
clear variables;
close all;

currentdir = pwd;
addpath(pwd);
main = uigetdir();
[filepath, name] = fileparts(main);

cd(main);
files = dir('*.tif');
numberfiles= numel(files);

summary =  zeros(numberfiles, 13);

%case, GFP volume, MC1 signal, MC1 background, MC1 corrected

resolution = 1/5.544; %micrometers per pixel
depth = 0.334515; %stepsize
voxel = (resolution^2)*depth;

for i=1:numberfiles

currentfile= [num2str(i),'.tif'];
summary(i,1) = num2str(i);
data=bfopen(currentfile);
planes=data{1,1}; %contains the stack arrange as c1, c2, c3.. where GFP is C1 and Tau Dako is C2
gfp_signal= [];
mc1_signal= [];
cherry_signal= [];
% 3.5 The second loop begins, to generate stacks for each channel
    for j= 1:3:size(planes, 1)
        gfp_signal = cat(3,gfp_signal,planes{j});
    end
    for j= 2:3:size(planes, 1)
        cherry_signal = cat(3,cherry_signal,planes{j});
    end
    for j= 3:3:size(planes, 1)
        mc1_signal = cat(3,mc1_signal,planes{j});
    end

average= mean(gfp_signal,[1 2]);
[a b] = max(average);
th = graythresh(gfp_signal(:,:,b));

gfpbw= imbinarize(gfp_signal,1.5*th);

gfpvalue = gfp_signal;
gfpvalue(gfpbw==0)=0;
summary(i,3) = mean(gfpvalue(gfpvalue~=0));
gfpbg = gfp_signal;
gfpbg(gfpbw==1)=0;
summary(i,4) = mean(gfpbg(gfpbg~=0));
summary(i,5) = summary(i,3) - summary(i,4);

mc1value = mc1_signal;
mc1value(gfpbw==0)=0;
summary(i,6) = mean(mc1value(mc1value~=0));
mc1bg = mc1_signal;
mc1bg(gfpbw==1)=0;
summary(i,7) = mean(mc1bg(mc1bg~=0));
summary(i,8) = summary(i,6) - summary(i,7);

cherryvalue = cherry_signal;
cherryvalue(gfpbw==0)=0;
summary(i,9) = mean(cherryvalue(cherryvalue~=0));
cherrybg = mc1_signal;
cherrybg(gfpbw==1)=0;
summary(i,10) = mean(cherrybg(cherrybg~=0));
summary(i,11) = summary(i,9) - summary(i,10);

summary(i,12) = summary(i,8)/summary(i,5); %MC1 to GFP ratio
summary(i,13) = summary(i,8)/summary(i,11); %MC1 to Cherry ratio
end

results = array2table(summary);
results.Properties.VariableNames = {'Brain', 'GFP volume', 'GFP signal','GFP background', 'GFP corrected', 'MC1 signal' 'MC1 background', 'MC1 corrected', ...
  'Cherry signal', 'Background cherry', 'Cherry corrected', ' MC1/GFP', 'MC1/Cherry'};
writetable(results,[name,'_results.csv']);

close all;
clear variables;
clc;

