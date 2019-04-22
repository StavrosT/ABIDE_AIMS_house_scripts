
#!/bin/bash/env python
# loop for extracting mean on summary statistics csvs 


#Import modules
import os
import numpy as np
import pandas as pd

# Sepcify csv file name to import
sumstats = './CSV/rest_motion_fd_summary_stats.csv'

# Read file as csv
sumstats = pd.read_csv(sumstats, header=None)
MeanFD = sumstats.loc[1,1]

# Insert MeanFD value into a DataFrame
DF_Mean_FD = pd.DataFrame(np.array([MeanFD]))

# Specify file path to save DataFrame as csv

##preprocpath = '/Users/stavrostrakoshis/Documents/Caltech_scans/MeanFD/MeanFD.csv'
# Make this a file
##preprocpath = open('/Users/stavrostrakoshis/Documents/Caltech_scans/MeanFD/MeanFD.csv', 'a+')
##Something like this is probably needed


# Append DataFrame into csv
DF_Mean_FD.to_csv('/Users/stavrostrakoshis/Documents/Caltech_scans/MeanFD/MeanFD.csv', header=None, encoding='utf-8', mode='a')

