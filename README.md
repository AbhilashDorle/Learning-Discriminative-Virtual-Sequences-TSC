# Learning-Discriminative-Virtual-Sequences-TSC

INTRODUCTION:

The code refers to the paper "Learning Discriminative Virtual Sequences for Time Series Classification, Abhilash Dorle, F.Li, W.Song, Sheng Li, CIKM'20"

We implement our code on various datasets from UCR time series archive

USAGE:

1. Convert the data in the following format:

   Column 1: Label of the time series sample
   
   Column 2 onwards the time series

We follow the format used the UCR time series archive

2. Change the location in train.mat and test.mat to the dataset location

3. Hyperparameter tuning may be required for new datsets. This can be done in driver_dtw.m

4. Run driver_dtw.m

Citation:

Please cite the paper "Learning Discriminative Virtual Sequences for Time Series Classification", Conference on Information and Knowledge Management, 2020
