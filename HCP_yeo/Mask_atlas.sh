#Mapping yeo networks to HCP Glasser 2016 template
#Depends on afni
#Is called by Mask_atlas.sh
#Stavros Trakoshis
#2020



rootpath=~/Desktop/HCP_yeo
codepath=$rootpath/code
outputpath=$rootpath/ouput
maskfile=Yeo2011_7Networks_MNI152_FreeSurferConformed1mm.nii.gz 
inputfile=MMP_in_MNI_symmetrical_1.nii.gz

outname="HCP_Regions_in_Network"

#mkdir output
if [ ! -d $outputpath ]
then
	mkdir $outputpath
fi

#No of Networks in template
N_Networks=7


for i in $(seq 1 $N_Networks)
do
	3dmaskdump -mask $maskfile -mrange $i $i -nozero -noijk $inputfile >> $outputpath/${outname}${i}.txt
	echo +++++++++++++++++++++
	echo We are in Network ${i}
	echo +++++++++++++++++++++
done

echo **+ Loop Done 

cd $outputpath

echo +++++++++
echo we are in $(pwd)
echo +++++++++

for i in *.txt
do
	echo +++++++++
	echo working on $i
	echo +++++++++

	outname2="Networks_unique.csv"

	python3 $codepath/unique_parcels_in_output.py "$i" "$outputpath" "${i}$outname2"

done
	echo *********
	echo Done
	echo *********


