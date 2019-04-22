#!/bin/bash 

#This script loops in every site in ABIDE 1
#extracts the Erest_pp.nii.gz, motion_fd.txt, dvars.txt, _spp_rest.sh 
#for MRC_aims it also takes the raw rest.nii.gz and mprage.nii.gz
#makes a new file with them and insert subject's id into filename.
#then it is sent into the corresponding site dir into general destination
#dir. Site dir is then gunziped, finally the full destination dir is gunzip

#started 02.12.2018
#Stavros Trakoshis


#Things to extract
goodstuff="rest_pp.nii.gz motion_plot.pdf rest_motion_fd.txt rest_motion.1D rest_SP.txt *dvars.txt _spp_rest.sh rest_motion_fd_summary_stats.csv"


#Paths

abidepath=~/Documents/ABIDE_1

destinationpath=$abidepath/ABD_1_PP_zipped
mkdir $destinationpath


#list of sites
sitelist="Caltech_scans_less CMU_a CMU_b KKI Leuven_1 Leuven_2 MaxMun NYU Olin Oregon Pitt SanDiego SBL Stanford Trinity UCLA_2 UM_1 UM_2 USM_Scans VBM_a Yale_scans"


#outerloop
for site in $sitelist
do

	#site destination
	sitedestination=$destinationpath/${site}_PP

	mkdir $sitedestination

	#sitepath
	sitepath=$abidepath/$site

	cd $sitepath
	echo "**+ In $site now"


	#get subjects

	subjlist=$(printf '%s\n' *0* | paste -sd " ")

	for sub in $subjlist
	do

		echo "**+ In $sub of $site"
		subpath=$sitepath/$sub
		preprocpath=$subpath/session_1/preproc_*

		#subdestination

		subdestination=$sitedestination/${sub}_PP 
		mkdir $subdestination


		cd $preprocpath
		pwd

		#loop through list to extract, and ask find to find it
		#pipe it to cp
		#explicitly state target dir with: -t
		#takes pattern case insensitivy: -iname 
		#xargs is a temporary variable, commonly used with whatever find spits out

		for i in $goodstuff
		do
			echo $i 
			find . -iname "${i}" | xargs cp -t $subdestination/
		done


	done #subloop

	cd $destinationpath

	
	#call tar to tar gz the directory
	#Only command in the world that doesn take  -  before ARGS


	tar zcfv ${site}_PP.tar.gz $sitedestination


	echo "**+ ${site} done"

	cd $abidepath

done #outerloop




