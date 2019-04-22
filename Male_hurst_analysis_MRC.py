#!/bin/bash/env python3
#This one is for MRC


#Import libraries 
import pandas as pd
from pandas import plotting #pandas plotting
import matplotlib.pyplot as plt #makes plots appear
import scipy 
import numpy as np
from os.path import join #Like matlabs fullfile
from statsmodels.formula.api import ols #For R like formulas 
from statsmodels.stats.multitest import fdrcorrection #FDR from statsmodels

#Paths
rootpath = "/Users/stavrostrakoshis/Documents/MRC_Hurst"
codepath = join(rootpath, "code")
datapath = join(rootpath, "data")
phenopath =join(rootpath, "pheno")

#Read in file
pheno_file = join(phenopath, "tidy_data.xlsx")

pheno_data = pd.read_excel(pheno_file)

ardata = pd.DataFrame(pheno_data) #dataframe

#Subset only males
maledata = ardata.loc[ardata['Sex'] == "M"]  

#Subset use subs

pheno_data_males = maledata.loc[maledata['use_subs'] == 1]

#First col as row names used to be here but it messes up the indexing later!
#Good thing to remember that order matters


#Get subject list to loop over

subjlist = pheno_data_males['sub_id']
subjlist = subjlist.values #makes it an array from df

#First col as row names (index in python)

pheno_data_males = pheno_data_males.set_index('sub_id')

#Empty frame
colnum = 180
tmp_data = pd.DataFrame(np.zeros((len(subjlist), colnum)))
tmp_data = tmp_data.set_index(subjlist)  #names rows

#Make an empty list 


colnumlist = np.arange(1,colnum+1)

#Make an empty list 

colnames = []

#Loop for col names
for g in colnumlist:
 	colnames.append('Parcel_%s' % (g))

#Name empty matrix columns with colnames

tmp_data.columns = colnames


#Read in csvs for each subject

for isub in list(subjlist):
	SubHurst = '%s__Hurst.csv' % (isub)
	subfname = join(datapath, SubHurst)
	data12 = pd.read_csv(subfname, header=None)
	tmp_data.loc[isub] = data12.values


'''''''''''
#Unlock to
#make a preliminary output for visual checking
PO = 'tmp_data.csv'
tmp_data_path = join(phenopath, PO)
tmp_data.to_csv(tmp_data_path)
'''''''''
 	
#Join them into a big frame

frames = [pheno_data_males, tmp_data]
extended_pheno_data_males = pd.concat(frames, axis=1) 

#Write it 

ExtPDM = 'extended_pheno_data_males.csv'
ExtPDMpath = join(phenopath, ExtPDM)
extended_pheno_data_males.to_csv(ExtPDMpath) 

#Mean (etc) of stuff
extended_pheno_data_males[extended_pheno_data_males['Diagnosis'] == 'TD']['FIQ'].mean()
#for more indexing
extended_pheno_data_males[extended_pheno_data_males['Diagnosis'] == 'TD'][['FIQ', 'VIQ']].mean()



#Or
#for general descriptives
extended_pheno_data_males.describe()

#Groupby for better implementation
#cleaner aesthitics 
#groupby spits/is an object

ASD_TD_pheno_datamales = extended_pheno_data_males.groupby('Diagnosis')
ASD_TD_mean = ASD_TD_pheno_datamales.mean()
ASD_TD_max = ASD_TD_pheno_datamales.max()

'''
#Plot some of them (?)
plotting.scatter_matrix(extended_pheno_data_males[['FIQ', 'Parcel_64','Parcel_148']])
plt.show() #shows
plt.close() #terminates figure?
plotting.scatter_matrix(extended_pheno_data_males[['FIQ', 'Parcel_1','Parcel_2', 'Parcel_3', 'Parcel_4', 'Parcel_5', 'Parcel_6', 'Parcel_7', 'Parcel_8', 'Parcel_9', 'Parcel_10', 'Parcel_11', 'Parcel_12', 'Parcel_13', 'Parcel_14', 'Parcel_15']])
plt.show()  #looking for bimodal plots as if there are 2 populations
'''
#STATS - R like formulas

#Regression
#Simple
model = ols("Parcel_48 ~ FIQ", extended_pheno_data_males).fit()  
print(model.summary())


model = ols("Parcel_48 ~ Diagnosis + 1", extended_pheno_data_males).fit() #this is basically a an anova - binary/categorical..
print(model.summary()) #p significant!

#Multiple
model = ols("Parcel_48 ~ Diagnosis + Parcel_148", extended_pheno_data_males).fit()
print(model.summary()) #there is an effect of region 148, to region 48 irrespective of diagnosis


###

#ANOVA

groups = pd.unique(extended_pheno_data_males.Diagnosis.values) #this gets the unique values in 'Diagnosis'
####



output_res = pd.DataFrame(np.zeros(shape=(colnum, 2))) #empty df to write results
output_res = pd.DataFrame(output_res) #make sure! 



parcel_names = []
for col in colnumlist:
	parcel_names.append('Parcel_%s' % col)

output_res.insert(loc=0, column='Parcel_num', value=parcel_names) #parcel_names as first col

output_res.set_index('Parcel_num', inplace=True) #name rows from 1st col / inplace


output_res.columns = ['T-test', 'p_value']  #names cols

#Takes the value of H in each parcel for each subject in every group
#Performs independent t-test from scipy
for col in colnumlist:
	tmp_parcelASD = extended_pheno_data_males[extended_pheno_data_males['Diagnosis'] == 'Autism']['Parcel_%s' % col] 
	tmp_parcelTD = extended_pheno_data_males[extended_pheno_data_males['Diagnosis'] == 'TD']['Parcel_%s' % col] 
	tmp_result = scipy.stats.ttest_ind(tmp_parcelASD, tmp_parcelTD, nan_policy='omit')
	tmp_result = list(tmp_result)
	output_res.loc['Parcel_%s' % col] = tmp_result

#Adjusting the p value
FDRcor = fdrcorrection(pvals=output_res['p_value'], alpha=0.05) # also returns a bolean if hypothesis has been rejected
bolFDRcor = FDRcor[0]
qvalFDRcor = FDRcor[1]
output_res['q_value'] = qvalFDRcor
output_res['bolFDR'] = bolFDRcor

#Save it 
output_resname1 = 'FDRcorrected_ASD_vs_TD_parcelwiseTtest.csv'
output_res.to_csv(join(phenopath, output_resname1))

#PLOTS  for FDR surviros


parcel_64 = 'Parcel_64'
plotting.boxplot(extended_pheno_data_males, column='Parcel_64', by='Diagnosis')
plt.savefig(join(phenopath, parcel_64))




parcel_148 = 'Parcel_148'
plotting.boxplot(extended_pheno_data_males, column='Parcel_148', by='Diagnosis')
plt.savefig(join(phenopath, parcel_148))







