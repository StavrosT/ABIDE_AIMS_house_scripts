rootpath=/home/stavros/Documents/ABIDE_1/111_MRC_AIMS/rsfMRI/raw_data/
cd $rootpath
for g in *0*
do
	cd $g/preproc_2
	pwd && echo "I am in ${g}"
	rm LG_3DR_list.txt
	echo "${g}" >> ~/Documents/LG_3DR_MRC_list.txt
	echo $(printf '%s\n' LG_3DR*) >> ~/Documents/LG_3DR_MRC_list.txt

	cd $rootpath
done
