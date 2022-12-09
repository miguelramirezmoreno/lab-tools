%code to extract Ecc and MTSD values on a cell by cell basis to obtain
%comparisons among genotypes. It requires running PCP_MT and
%fulldistributionwithMTSD scripts by N Bulgakova (Last revision November
%2022).

clc;
close all;
clear variables;

currdir = pwd;
addpath(pwd);
filedir = uigetdir();
cd(filedir);


celldir = [filedir, '/summary/cellbycell'];
sumdir = [filedir, '/summary'];

cd(celldir);
files = dir('*.csv');


celldata = zeros(1,6);
% distdata = zeros(45,1);
for loop = 1:numel(files)
    cd(celldir);
    celldata = [celldata; csvread(['Summary_MTSD',num2str(loop),'.csv'], 1,4)]; %#ok<AGROW>
%     cd(distdir);
%     distdata = [distdata, csvread([num2str(loop),'_distribution.csv'],0,1)]; %#ok<AGROW>

end

cd(sumdir);
celldata(1,:) = [];
clean_celldata = celldata;
eccentric= find(clean_celldata(:,3)>90);
clean_celldata(eccentric,:)= [];

summary_filename = ['ecc_MTSD_cleaned_cells','.csv'];
header = {'Eccentricity','Direction_cell', ...
    'SD', 'DEV', 'Elongation', 'Alignment'};
csvwrite_with_headers(summary_filename,clean_celldata,header);

summary_filename = ['ecc_MTSD_all_cells','.csv'];
header = {'Eccentricity','Direction_cell', ...
    'SD', 'DEV', 'Elongation', 'Alignment'};
csvwrite_with_headers(summary_filename,celldata,header);
