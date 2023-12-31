# MFGJ(Multi-feature GNSS Jamming dataset)
(If you are benefited from this dataset, please cite us.) It can be downloaded from and extract by (MFGJ_Dataset.zip):  
  * [BaiduYun Drive(code: 0224)](https://pan.baidu.com/s/1AmDVWar6LDd4oIWqy3Hi7Q)

  The MFGJ dataset is divided into a training set and a test set with a JSR in the range of **[15db, 50db]**,where there are a total of **46,800** spectrogram images in the training set and **21,600** spectrogram images in the test set, for a total of 68,400 spectrogram images. 
## Distribution of Datasets
Train\Test | 00Clean | 01CWI | 02DME | 03Hooked-<br>Sawtooth | 04Linear | 05Triangular | 06Triangular-<br>Wave | 07Sawtooth | 08Tick | 09DSSS | 10NBFMJ | 11BLGNI
 :----: | :----: | :----: | :----: | :----: | :----: | :----: | :----: | :----: | :----: | :----: | :----: | :----: |
***Train*** |*3600*|*3600*|*3600*|*3600*|*3600*|*7200*|*3600*|*3600*|*3600*|*3600*|*3600*|*3600* 
***Test***  |*1800*|*1800*|*1800*|*1800*|*1800*|*1800*|*1800*|*1800*|*1800*|*1800*|*1800*|*1800*
## Dataset Annotations
  Annotations are embedded in file name. 
  A sample image name is "image00001_01CWI_jsr15", Each name can be splited into THREE fields. Those fields are explained as follows.  
 * ***image_index***:The index number of the image under the corresponding category  
 * ***type***: Classes of jamming in GNSS
 * ***JSR***: JSR of the corresponding image  
  `<type = ["00Clean", "01CWI", "02DME", "03HookedSawtooth", "04Linear", "05Triangular", "06Triangular-<br>Wave", "07Sawtooth", "08Tick", "09DSSS", "10NBFMJ", "11BLGNI"]>`  
 `<JSR = [15, 50]>`  
## Dataset Generation
  We publish the code for generating MFGJ datasets in the MFGJdata_Generate folder, so that you can generate a customized number of MFGJ datasets according to your needs.  
