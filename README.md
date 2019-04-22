# Scripts for in-house use on the ABIDE and AIMS data

Can be probably used on other rs-fMRI data

These scripts usually use: <br />
Standard bash commands <br />
Various afni programs <br />
Various fsl programs <br />
Python2 and 3 and various libraries within there - including all anacoda libraries. <br />
Some matlab and SPM12 scripts <br />


These scripts are meant to be complementary to speedyppX.py, which is our main preprocessing tool. <br />
Ref: <br />
De-noising module adapted for motion artifact removal by Patel, AX. (2014). <br />


Alphabetical list of scripts and short bio: <br />

3dResample_loop.sh - Resamples an atlas TO the rest_pp, Fractal_loop depends on this. <br />
BET_runsecondrun.sh - Extensive bet, other than the speedy default.__ <br />
Clean_up_beforedoing_speedy.sh - Deprecated, use Remove_after_speedy.sh for similar things.__ <br />
CUT_first_vol.sh - Removes first N volumes from AIMS rsfmri. <br />
Change_names.sh - Changes names <br />
export_good_stuff.sh - Extracts useful output from the preprocessed directories.__ <br />
FCN.m - IGNORE it - Attempt to make Functional Connectivity script.__ <br />
Fractal_loop.m - Calculates Hurst on Glasser parcels. <br />
Hmap_Loop.m - Loops over sucjects and calls compute_hmap.m.__ <br />
Male_hurst_analysis_MRC.py - Mass Univariate T-test on parcellated Hurst in AIMS.__ <br />
Male_hurst_analysis_USM_Scans.py - Mass Univariate T-test on Hurst in ABIDE_1 USM.__ <br />
Mean_FD_looper.sh - extracts Mean_FD from rest_motion_fd_summary_stats.csv.__ <br />
Melodic_DualR.sh - Dual regression with FSL.__ <br />
N_vols.sh - Finds number of volumes from ABIDE data.__ <br />
plot_fd_dvars.py - Plots fd and dvars.__ <br />
plot_fd_dvars_looper.sh - Loops plot_fd_dvars.py on ABIDE data.__ <br />
Powerspectrum_loop.m - Makes various PSD plots from timeseries csvs.__ <br />
Preprocessing_Script_Master_1.sh - Main preprocessing pipeline for rsfMRI data.__ <br />
Remove_after_speedy.sh - Removes things from the final preprocessing dir for space saving.__ <br />
Summary_csv_looper.py - MeanFD_looper.sh depends on this to exract MeanFD.__ <br />
UBUNTU_largest_grid.sh - Calculates number of voxels for each subject for ABIDE data.__ <br />
UBUNTU_largest_grid_Step2.sh - Finds single subjects with the largest grid, for ABIDE.__ <br />


