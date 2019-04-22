#!/bin/bash
# Name: UBUNTU_largest_grid.sh
#This script takes the dimension information from each rest_pp in an ABIDE_1 site.

#Add calculation of the largest grid and 3dresample in the future (!?)
###############################################################
###############################################################



#Define path to txt file
OUTPUTPATH=$HOME/Documents

#Insert sites using strings
SITENAME="USM_Scans"

#Outer rootpath where all ABIDE sites are stored
OUTER_ROOT=/home/stavros/Documents/ABIDE_1

#Enter site at the end
SITEPATH=$OUTER_ROOT/$SITENAME


	#cd into site
	cd $SITEPATH

	#prepare subject list (printf works better than ls)
	#and throw it into a variable
	SUBJLIST=$(printf '%s\n' *0*)

	#echo it
	echo "$SUBJLIST             THESE ARE THE SUBJECTS"

	#Inner for loop begins
		for SUB in $SUBJLIST
		do
			cd $SUB/session_1

			#Check which preproc is there. preproc_2 is preferable
			if [ -d preproc_2 ]
				then

			#cd into preproc_*
			cd preproc_2

		elif [ -d preproc_1 ]
			 then

			 cd preproc_1

			else
				echo "**WARNING no preproc directory in ${SUB}** " >> ${SITENAME}_WARNINGS.txt
				echo "**WARNING no preproc directory in ${SUB}** "
				mv ${SITENAME}_WARNINGS.txt $OUTPUTPATH/Grid/ 
			fi

			#statements


			if [ -e rest_pp.nii.gz ]
				then
				echo $SUB >> $OUTPUTPATH/subjects_information.txt && echo $(3dinfo -nijk rest_pp.nii.gz) >> $OUTPUTPATH/dimension_information.txt
			else
				echo $SUB >> $OUTPUTPATH/subjects_information.txt && echo "NaN" >> $OUTPUTPATH/dimension_information.txt
			fi

			#Go back
			cd $SITEPATH

		#loop ends
		done


#After dones
#this will append files vertically
cd $OUTPUTPATH
paste subjects_information.txt dimension_information.txt > ${SITENAME}_GRID_by_SUBJECT.txt

mv ${SITENAME}_GRID_by_SUBJECT.txt $OUTPUTPATH/Grid

	
retVal=$?
if [ $retVal -eq 0 ]; then
    echo "**Results have been safely stored in Grid directory**"
    fi
    
rm subjects_information.txt dimension_information.txt
