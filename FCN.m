% function Subject_Series = FCN(datafiles, maskfile, cohortN, outname)
% Resample the resulting fALLF etc maps to the LG_3RD_* template!
% 3dRSFC -notrans -band 0 9999 -input RS_ucla_pp.nii.gz  -mask ../01_MRC_AIMS/LG_3DR_MMP.nii.gz 


%Path to group parent directory
rootpath = '/Users/stavrostrakoshis/Desktop/3dRSFC/NEWTEST';

%output
outname = fullfile(rootpath,'subject_series_raw');
outnamestats = fullfile(rootpath,'subject_series_stats');

%Get subdir list - every subjets has a 0 in their id - usually
d = dir(fullfile(rootpath, '*0*'));

%Get the size of how many subdirs in parent dir and feed it to cohortN
cohortN = length(d);

%get maskfile 
maskfile = fullfile(rootpath,'Templates', 'LG_3DR_ALL.nii.gz');


%read mask
[mask, dims, scales] = read_avw(maskfile);
mask = logical(mask);
% number of brain voxels in mask
nbrainvoxels = sum(mask(:));
%empty matrix to produce 'subject series'
data_mat = zeros(cohortN, nbrainvoxels);
%% Recunstructing for NIfTI writting
% find indices of brain voxels
brain_idx = find(mask);

% Find x, y, z subscripts for each brain voxel
% ind2sub is used to determine the equivalent subscript values
[x,y,z] = ind2sub(size(mask),brain_idx);
    
for i=1:length(d)
    
    %% Data stuff
    subname = d(i).name;
    subpath = fullfile(rootpath, subname);
    disp(subpath);
    datafile = fullfile(subpath,'RSFC_ALFF.nii');
    
    %read file
    [data] = read_avw(datafile);
    %make a 2d object of the datafile
    data_mat(i,:) = data(mask);
end % i

%% Makes an equivalent 3D matrix in memory
Map_data_mat = zeros([size(mask), cohortN]);
%% Give to the matrix the 4th dimension related to cohort size, and 
% itteration


for isub = 1:cohortN
    for ivox = 1:length(brain_idx)
        Map_data_mat(x(ivox), y(ivox), z(ivox), isub) = data_mat(isub, ivox); 
    end
end

%% Write it to NIfTI
% replace fourth element of scales with cohort number
scales(4) = cohortN
vsize = scales; vtype = 'f';
save_avw(Map_data_mat, outname, vtype, vsize); 

%% Covariance
% the 2d matrix subject(cohortN) x voxels is used
clear C
C = cov(data_mat); %

CNorm = cov(data_mat,1); %normalized