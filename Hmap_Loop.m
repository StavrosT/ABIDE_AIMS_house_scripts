%Paths
rootpath = '/home/stavros/Documents/ABIDE_1/MRC_AIMS/rsfMRI/raw_data';


%compute_hmap.m fixed arguments
maskfile = fullfile(rootpath, 'MNIs','LG_3DR_MNI152_T1_1mm_brain.nii.gz');
nchunks = 400;
%Get subdir list - every subjets has a 0 in their id
d = dir(fullfile(rootpath, '*0*'));

%loop to each subject's EPI

for subid=1:length(d)
    subname = d(subid).name;
    disp(subname);
    subpath = fullfile(rootpath, subname);
    disp(subpath);
    %compute_hmap.m data to use
    datafile = fullfile(subpath, 'preproc_2', 'LG_3DR_Erest_pp.nii.gz')
    %outname with the amount of millimeters *_mm in parcellation
    outname = fullfile(subpath, 'preproc_2', 'Erest_Hmap_1mm_.nii.gz')
    %call compute_hmap.m
    Hmap = compute_hmap(datafile, maskfile, outname, nchunks);
    
end %ends for