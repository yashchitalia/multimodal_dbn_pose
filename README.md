# multimodal_dbn_pose-- Yash Chitalia
This code is designed to perform multimodal pose estimation on a mixed dataset of 
RGB and Depth images. We use Restricted Boltzmann machines to acheive pose
estimation under heavy occlusion. 
You will find the following important files in the repository:
1.    Yash_RBM/dbn_multi_modality_1_layer.m: Shallow Multimodal DBN.
2.    Yash_RBM/dbn_single_modality_1_layer.m: 1-Layer Gaussian Binary RBM(baseline)
3.    Yash_RBM/dbn_single_modality_4_layer.m: 4-layer unimodal DBN.

Also, you will find the following data preprocessing files 

1.  preprocess_cad60.py
2.  cad60_dataset.py

The following are some steps to reproduce what we have done:
Step 1: Please download the CAD60 repository from the following link:
        --> http://pr.cs.cornell.edu/humanactivities/data.php
Step 2: Create a directory structure called data/cad60_dataset/ in the current
directory, and paste contents of the downloaded folder into the
cad60_directory.

Step 3: Run preprocess_cad60.py

Step 4: Run cad60_dataset.py. This will create a set of directories and
datafiles inside the folder. Copy the following into the Yash_RBM directory:
1.  d_occ.mat
2.  d_orig.mat
3. rgb_orig.mat
4.  rgb_occ.mat

Step 5: Run any of the files beginning with dbn*.m in the Yash_RBM directory.
Each of these files executes a certain type of Deep Belief network. At the end
of each epoch, the RMSE and Free Energy of the RBMs will be displayed. Finally,
the output is visualized on a zero-mean unit variance image of the data. Also,
after each RBM in each layer is executed, it will display a plot of its free
energy. This will help to decide if the learning is going on well.

-------------------------------------------------------------------------------
Our Contribution:
1. We have developed our own occlusion algorithm for depth and RGB data coming
   from a Kinect sensor. This has been implemented using the dataset CAD-60
provided by Cornell. The occlusion resembles that of a patient lying on a
hospital bed. Thus the RGB is occluded by a rectangle that looks like a blanket
and the Depth map is occluded by small black patches aroung each joint. To
understand the thought process behind the occlusion, please refer to the
report.
2. We have, to our knowledge developed the first implementation of Multimodal
   DBN for regression. This is also the only implementation of multimodal DBN
in MATLAB which is freely available. All the DBNs developed in the above
tutorial are written by us, using a skeleton of the code provided by Ruslan
Salakhutdinov on his website. Other than naming conventions and style of
coding, our code is written independently.
3. We used the RBM functions provided by Ruslan Salakhutdinov, and by Masayuki
   Tanaka. We modified them to be able to compute free energy, and to be
compatible with each other. 
4. All functions to randomize data, preprocess and make batches, as well as
   visualization of the output have been written by us.


[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/yashchitalia/multimodal_dbn_pose?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
