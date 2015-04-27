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


% This program pretrains a deep autoencoder a single modal DBN with 4
% layers, and feeds the output to a linear regression algorithm. This is
% used as a baseline performance.

clear all
close all
clc

maxepoch=15; %Number of epochs 
% numhid=2700; numpen=1500; numpen2=750; numopen=500;%RGB
numhid=1000;numopen=700;%RGB

fprintf(1,'Make sure all the preprocessed files exist \n');
% prep_data;

fprintf(1,'Pretraining a 4 layer DBN. \n');
fprintf(1,'This uses %3i epochs\n', maxepoch);

makebatches_rgb;
%makebatches_d;
saved_accuracy = [];
save saved_rmse_two_layer saved_accuracy;

[numcases numdims numbatches]=size(batchdata);

fprintf(1,'Pretraining Layer 1 with RBM: %d-%d \n',numdims,numhid);
% restart=1;
% rbm;
% hidrecbiases=hidbiases; 
% save dbn4vh vishid hidrecbiases visbiases;
rbm1 = randRBM( numdims, numhid, 'GBDBN' );
rbm1.sig = std(batchdata);
opts.BatchSize = numcases;
opts.MaxIter = maxepoch;
opts.Verbose = true;
opts.StepRatio = 0.1;
X = [];
for i = 1:numbatches
    X = [X; batchdata(:,:,i)];
end
restart=1;
opts.object = 'CrossEntropy';
rbm1.sig = std(X);
rbm1 = pretrainRBM(rbm1, X, opts);
vishid = rbm1.W;
hidrecbiases = rbm1.b;
visbiases = rbm1.c;
X = v2h(rbm1, X);
batchposhidprobs2 = [];
for b=1:numbatches
  batchposhidprobs2(:,:,b) = X((1+(b-1)*numcases:b*numcases), :);
end;

save dbn4vh vishid hidrecbiases visbiases;

% fprintf(1,'\nPretraining Layer 2 with RBM: %d-%d \n',numhid,numpen);
% batchdata=batchposhidprobs2;
% numhid=numpen;
% restart=1;
% rbm;
% hidpen=vishid; penrecbiases=hidbiases; hidgenbiases=visbiases;
% save dbn4hp hidpen penrecbiases hidgenbiases;
% 
% fprintf(1,'\nPretraining Layer 3 with RBM: %d-%d \n',numpen,numpen2);
% batchdata=batchposhidprobs;
% numhid=numpen2;
% restart=1;
% rbm;
% hidpen2=vishid; penrecbiases2=hidbiases; hidgenbiases2=visbiases;
% save dbn4hp2 hidpen2 penrecbiases2 hidgenbiases2;

fprintf(1,'\nPretraining Layer 2 with RBM: %d-%d \n',numhid,numopen);
batchdata=batchposhidprobs2;
numhid=numopen; 
restart=1;
rbmhidlinear;
hidtop=vishid; toprecbiases=hidbiases; topgenbiases=visbiases;
save dbn4po hidtop toprecbiases topgenbiases;

linear_regress_dbn4_single; 

