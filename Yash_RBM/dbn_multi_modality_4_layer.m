% Version 1.000
%
% Code provided by Ruslan Salakhutdinov and Geoff Hinton  
% Code modified by Yash Chitalia
% Permission is granted for anyone to copy, use, modify, or distribute this
% program and accompanying programs and documents for any purpose, provided
% this copyright notice is retained and prominently displayed, along with
% a note saying that the original programs are available from our 
% web page. 
% The programs and documents are distributed without any warranty, express or
% implied.  As the programs were written for research purposes only, they have
% not been tested to the degree that would be advisable in any important
% application.  All use of these programs is entirely at the user's own risk.


% This program pretrains a deep autoencoder a single modal DBN with 1
% layer, and feeds the output to a linear regression algorithm. This is
% used as a baseline performance.

clear all
close all
clc

maxepoch=10; %Number of epochs 
numhid1= 750; 
numopen = 30;


fprintf(1,'Make sure all the preprocessed files exist \n');
% prep_data;

fprintf(1,'Pretraining a 1 layer RBM. \n');
fprintf(1,'This uses %3i epochs\n', maxepoch);
%%%%%%%%%%%%%%%%%%%%%%%% FIRST ONE LAYER OF DEPTH %%%%%%%%%%%%%%%%%%%%%%%%%
makebatches_d;
%makebatches_rgb;

[numcases numdims numbatches]=size(batchdata);
fprintf(1,'Pretraining Layer 1 with D: %d-%d \n',numdims,numhid1);
rbm1 = randRBM( numdims, numhid1, 'GBDBN' );
opts.BatchSize = numcases;
opts.MaxIter = maxepoch;
opts.Verbose = true;
opts.StepRatio = 0.1;
X = [];
for i = 1:numbatches
    X = [X; batchdata(:,:,i)];
end
restart=1;
%rbm;
%hidrecbiases=hidbiases; 
opts.object = 'CrossEntropy';
rbm1 = pretrainRBM(rbm1, X, opts);
mm_vishid_d = rbm1.W;
mm_hidrecbiases_d = rbm1.b;
mm_visbiases_d = rbm1.c;
X1 = v2h(rbm1, X);
save mmdbn1vh_d mm_vishid_d mm_hidrecbiases_d mm_visbiases_d;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% NEXT ONE LAYER OF RGB %%%%%%%%%%%%%%%%%%%%%%%%%%%%
numhid2= 750; 
%makebatches_d;
makebatches_rgb;

[numcases numdims numbatches]=size(batchdata);
fprintf(1,'Pretraining Layer 1 with RBM: %d-%d \n',numdims,numhid2);
rbm2 = randRBM( numdims, numhid2, 'GBDBN' );
opts.BatchSize = numcases;
opts.MaxIter = maxepoch;
opts.Verbose = true;
opts.StepRatio = 0.1;
X = [];
for i = 1:numbatches
    X = [X; batchdata(:,:,i)];
end
restart=1;
%rbm;
%hidrecbiases=hidbiases; 
opts.object = 'CrossEntropy';
rbm2 = pretrainRBM(rbm2, X, opts);
mm_vishid_r = rbm2.W;
mm_hidrecbiases_r = rbm2.b;
mm_visbiases_r = rbm2.c;
X2 = v2h(rbm2, X);

save mmdbn1vh_r mm_vishid_r mm_hidrecbiases_r mm_visbiases_r;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% JOIN THE TWO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X3 = [X1 X2];
batchposhidprobs2 = [];
for b=1:numbatches
  batchposhidprobs2(:,:,b) = X3((1+(b-1)*numcases:b*numcases), :);
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% PRETRAIN THE COMBO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf(1,'\nPretraining Layer 2 with RBM: %d-%d \n',numhid1+numhid2,numopen);
batchdata=batchposhidprobs2;
numhid=numopen;
restart=1;
rbmhidlinear;
hidtop=vishid; toprecbiases=hidbiases; topgenbiases=visbiases;
save mmdbn1po hidtop toprecbiases topgenbiases;
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

linear_regress_dbn1_multi; 

