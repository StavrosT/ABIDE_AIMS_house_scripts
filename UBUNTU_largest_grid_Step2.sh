#######################
#!/bin/bash
#Calculates the largest number from a txt file
# UBUNTU_largest_grid_Step2.sh


#Enter grid info directory 
ROOTPATH=$HOME/Documents/Grid

cd $ROOTPATH
pwd


#Show largest number
for TXTFILE in *GRID*
do
	echo $TXTFILE
	#K2 means work on the second column
	## head -1 index with the previous column
	sort -nr -k2 $TXTFILE | head -1
	echo $(sort -nr -k2 $TXTFILE | head -1) >> LARGEST_numbers.txt
	echo $TXTFILE >> TXTfiles.txt
	
done 

paste TXTfiles.txt LARGEST_numbers.txt > LN_in_Site_final.txt
rm TXTfiles.txt LARGEST_numbers.txt