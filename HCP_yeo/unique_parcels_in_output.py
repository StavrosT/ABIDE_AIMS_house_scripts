#get unique values of txt file in output
#stavros trakoshis

#import libraries
import os
import pandas as pd
import numpy as np
import sys
#bash args

arg1=sys.argv[1]
arg2=sys.argv[2]
arg3=sys.argv[3]


def get_unique(txtfile, outputpath, outname):
	un="unique_"
	tmp_df=pd.read_csv(txtfile)
	arr_un=pd.Series(np.unique(tmp_df.values))

	out_outname=un+outname
	return_this=os.path.join(outputpath, out_outname)
	arr_un.to_csv(return_this)

	return print("File was saved in :", return_this)


if __name__=='__main__':
	get_unique(arg1,arg2,arg3)