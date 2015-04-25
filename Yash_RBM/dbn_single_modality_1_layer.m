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

maxepoch=20; %Number of epochs 
numhid= 1000; 

fprintf(1,'Make sure all the preprocessed files exist \n');
%prep_data;

fprintf(1,'Pretraining a 1 layer RBM. \n');
fprintf(1,'This uses %3i epochs\n', maxepoch);

makebatches_d;
%makebatches_rgb;

[numcases numdims numbatches]=size(batchdata);
fprintf(1,'Pretraining Layer 1 with RBM: %d-%d \n',numdims,numhid);
rbm1 = randRBM( numdims, numhid, 'GBDBN' );
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
rbm1.sig = std(X);
opts.object = 'CrossEntropy';
rbm1 = pretrainRBM(rbm1, X, opts);
vishid = rbm1.W;
hidrecbiases = rbm1.b;
visbiases = rbm1.c;
save dbn1vh_d vishid hidrecbiases visbiases rbm1;



linear_regress_dbn1_single; 

