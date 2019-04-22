#!/bin/bash
#Main preprocessing pipeline for ABIDE and AIMS rsfMRI data.

#Uses various afni programms
#Uses varios fmri_spt programs 

#Based upon speedyppX.py
# De-noising module adapted for motion artifact removal by Patel, AX. (2014).


# Insert subject id you want to process
sublist="0050682 0050683 0050685 0050686 0050687 0050688 0050689 0050690 0050691 0050692 0050693 0050694 0050695 0050696 0050697 0050698 0050699 0050700 0050701 0050702 0050703 0050704 0050705 0050706 0050707 0050708 0050709 0050710 0050711"

# Parallel Processing / Number of threads available for each AFNI programme
OMP_NUM_THREADS=8

# Insert rootpath were all CALTECH subject data is stored
rootpath=/home/stavros/Documents/ABIDE_1/Leuven_1

# Format speedyppX.py's options
FWHM=6
basetime=12
speedyoptions="-f ${FWHM}mm -o --coreg_cfun=lpc+ $basetime --betmask --nobandpass --ss MNI_caez --align_ss --qwarp --rmot --rmotd --keep_means --wds --threshold=10 --SP --OVERWRITE"

# Loop over subjects
for subid in $sublist
do
	# Path for specific subject to process
	subpath=$rootpath/$subid
	anatpath=$subpath/session_1/anat_1
	restpath=$subpath/session_1/rest_1
	#preprocpath1=$subpath/session_1/preproc_1
	preprocpath2=$subpath/session_1/preproc_2
	mkdir $preprocpath2

	# cd into directory 
	cd $preprocpath2

	# Create symbolic links to anat and rest in preprocpath2
	ln -s $restpath/rest.nii.gz $preprocpath2 # $preprocpath2/${subid}_preproc.sh
	ln -s $anatpath/mprage.nii.gz $preprocpath2 # $preprocpath2/${subid}_preproc.sh


	# Make sure -space field in the header is set to ORIG
	echo 3drefit -space ORIG $preprocpath2/mprage.nii.gz # $preprocpath2/${subid}_preproc.sh
	3drefit -space ORIG $preprocpath2/mprage.nii.gz 
	echo 3drefit -space ORIG $preprocpath2/rest.nii.gz # $preprocpath2/${subid}_preproc.sh
	3drefit -space ORIG $preprocpath2/rest.nii.gz
	# Call speedyppX.py
	echo python /home/stavros/rsfmri-master.OLD/speedyppX.py -d rest.nii.gz -a mprage.nii.gz $speedyoptions # $preprocpath1/${subid}_preproc.sh
	python2 /home/stavros/rsfmri-master.OLD/speedyppX.py -d rest.nii.gz -a mprage.nii.gz $speedyoptions
	# Compute framewise displacement with summary statistics
	echo python /home/stavros/rsfmri-master.OLD/fd.py -d rest_motion.1D # $preprocpath2/${subid}_preproc.sh
	python /home/stavros/rsfmri-master.OLD/fd.py -d rest_motion.1D
	# cd into spp.rest
	echo cd spp.rest # $preprocpath2/${subid}_preproc.sh
	cd spp.rest
	# Compute DVARS with summary statistics
	echo python /home/stavros/rsfmri-master.OLD/dvars_se.py -d rest_sm.nii.gz # $preprocpath2/${subid}_preproc.sh
	python /home/stavros/rsfmri-master.OLD/dvars_se.py -d rest_sm.nii.gz
	echo python /home/stavros/rsfmri-master.OLD/dvars_se.py -d rest_noise.nii.gz # $preprocpat21/${subid}_preproc.sh
	python /home/stavros/rsfmri-master.OLD/dvars_se.py -d rest_noise.nii.gz 
	echo python /home/stavros/rsfmri-master.OLD/dvars_se.py -d rest_wds.nii.gz # $preprocpath2/${subid}_preproc.sh
	python /home/stavros/rsfmri-master.OLD/dvars_se.py -d rest_wds.nii.gz
	
	# Run complete preprocessing batch script
	#bash $preprocpath2/${subid}_preproc.sh
	cd $preprocpath2

# Making PLOTS
# path to PLOTS 

    plotspath=$preprocpath2/PLOTS

	# Make $plotspath
    mkdir $plotspath

    # Change directory to $preprocpath2
    
    cd $preprocpath2
    
    # Write commands into bash script
    
    # Copy paste fd and dvars txt files into $plotspath
    mv rest_motion_fd.txt $plotspath 
    mv spp.rest/rest_sm_dvars.txt $plotspath 
    mv spp.rest/rest_noise_dvars.txt $plotspath 
    mv spp.rest/rest_wds_dvars.txt $plotspath 
    # cd into $plotspath
    cd $plotspath 
	# Format arguments for plot_fd_dvars.py
    FD=rest_motion_fd.txt
    DVARSSM=rest_sm_dvars.txt
    DVARSNOISE=rest_noise_dvars.txt
    DVARSWDS=rest_wds_dvars.txt
    plotpyoptions="--fd $FD --dvars_sm $DVARSSM --dvars_noise $DVARSNOISE --dvars_wds $DVARSWDS"
    
    # Run plot_fd_dvars.py
    python /home/stavros/fmri_spt/plot_fd_dvars.py $plotpyoptions --pdf2save motion_plot.pdf 
    
   
   

# cd back to $rootpath
    cd $preprocpath2
   done # for loop ends

####################################################
# Remove unwanted data - for space saving

# Ask first

  read -p "Please indicate whether you want to initiate Remove_after_speedy.sh ? [n/Y]: " EXPRESSION

# Evaluate answer
  if [ "$EXPRESSION" = "Y" ]
  	then
  	# Loop over subjects specified at the beginning
 	for subid in $sublist
	do
	# Path for each id
	 subpath=$rootpath/$subid
	 preprocpath2=$subpath/session_1/preproc_1
	 spprest=$preprocpath2/spp.rest
	
	# Remove files in preprocpath2
	files2remove="mprage*sppdo_at.nii.gz mprage_sppdo.nii.gz *.BRIK *.HEAD *_in*"
	echo cd $preprocpath2
	cd $preprocpath2
	echo rm -Rf $files2remove
	rm -Rf $preprocpath2/$files2remove


	# Move files to keep from spp.rest
	files2keep="*dvars.txt *csv *fd.txt PLOTS"
	echo cd $spprest
	cd $spprest
	echo mv $files2keep $preprocpath2
	mv $spprest/$files2keep $preprocpath2

	# Remove spp.rest
	echo cd $preprocpath2
	cd $preprocpath2
	echo rm -Rf $spprest
	rm -Rf $spprest

	# Mkdir for summary statistics

	echo "making summary statistics dir 'CSV' "
	mkdir CSV
	echo "moving csvs to CSV "
	mv *csv CSV

	# cd back to $rootpath
    cd $rootpath
   done # Loop ends

  else
  	echo "You didn't want to initiate Remove_after_speedy.sh ... EXITING.... "
  fi

