# Changes names in loops

List="42001 42002 42004 42004 42005 42007 42008 42009 42010 42012 42014 42014 42015 42016 42017 42018 42020 42021 42022 42024 42024 42025 42026 42027 42028 42029 42030 42031 42032 42033 42034 42035 42036 42037 42039 42040"
rootpath=/Users/stavrostrakoshis/Documents/MRC_AIMS/rsfMRI/raw_data
cd $rootpath


for i in $List
do
	subpath=$rootpath/$i
	cd $subpath
	#Change names
	mv ${i}_fspgr.nii.gz mprage.nii.gz
	mv ${i}_rsfmri.nii.gz rest.nii.gz

	#if mprage exists 
	if [ -e mprage.nii.gz ]
		then 
		echo "${i} mprage done!"
	else 
		echo "ERROR ${i} mprage NOT done!"
	fi
	#if rest exists
	if [ -e rest.nii.gz ]
		then
		echo "${i} rest done!"
	else
		echo "ERROR ${i} rest NOT done!"
	fi
	cd $rootpath
done




