roorpath=$(pwd)
for g in *0*
do
	cd preproc_2/CSV
	echo "I am in ${g}"
	head -1 ${g}_H.csv | sed 's/[^,]//g' | wc -c
	cd $rootpath
done