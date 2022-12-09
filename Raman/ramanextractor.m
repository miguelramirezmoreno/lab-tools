%Script to extract individual intensity profiles from Raman spectral
%dasets.

clc;
close all;
clear variables;

[filename,ramandir] = uigetfile('.txt');
cd(ramandir);

if exist([ramandir,'/spectral files'],'dir') == 0
    mkdir(ramandir,'/spectral files');
end

settings = inputdlg({'Enter row for shift values','Enter column for shift values', 'Enter row for first intensity', 'Enter column for first intensity'},'Input',1,{'4','2','9','5'});

shift_row = str2double(settings(1));
shift_column = str2double(settings(2));
intensity_row = str2double(settings(3));
intensity_column = str2double(settings(4));

filesdir = [ramandir, '/spectral files'];

ramandata= readcell(filename);
%readtable works too but gives error due to formatting
bin_number=numel(ramandata(intensity_row,intensity_column:end));
shifts = ramandata(shift_row, shift_column:bin_number+1);
leftcolumnarray=cell2mat(shifts);
leftcolumn=leftcolumnarray.';


all_files= ramandata(9:end, 5:end);
all_files=cell2mat(all_files);
all_filest=all_files.';
filenames= ramandata(9:end,1);
numberfiles= numel(filenames);

cd(filesdir); 

for i=1:numberfiles

    spectra_file = [leftcolumn, all_filest(:,i)];
    file_name= filenames(i);
    file_name=char(file_name);
    filetxt= [file_name +'.txt'];
    writematrix(spectra_file,filetxt, 'Delimiter','tab');
end


clc;
close all;
clear variables;
