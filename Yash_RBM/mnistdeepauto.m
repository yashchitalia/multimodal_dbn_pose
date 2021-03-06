% Version 1.000
%
% Code provided by Ruslan Salakhutdinov and Geoff Hinton  
%
% Permission is granted for anyone to copy, use, modify, or distribute this
% program and accompanying programs and documents for any purpose, provided
% this copyright notice is retained and prominently displayed, along with
% a note saying that the original programs are available from our 
% web page. 
% The programs and documents are distributed without any warranty, express or
% implied.  As the programs were written for research purposes only, they have
% not been tested to the degree that would be advisable in any important
% application.  All use of these programs is entirely at the user's own risk.


% This program pretrains a deep autoencoder for MNIST dataset
% You can set the maximum number of epochs for pretraining each layer
% and you can set the architecture of the multilayer net.

clear all
close all
clc

maxepoch=50; %Number of epochs 
numhid=1000; numpen=750; numpen2=500; numopen=30;%RGB
%numhid=2500; numpen=1250; numpen2=700; numopen=100; %Depth

fprintf(1,'Make sure all the preprocessed files exist \n');
%prep_data;

fprintf(1,'Pretraining a deep autoencoder. \n');
fprintf(1,'This uses %3i epochs\n', maxepoch);

makebatches_rgb;
[numcases numdims numbatches]=size(batchdata);

fprintf(1,'Pretraining Layer 1 with RBM: %d-%d \n',numdims,numhid);
% restart=1;
% rbm;
% hidrecbiases=hidbiases; 
% save mnistvh vishid hidrecbiases visbiases;
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
rbm1.sig = std(X);
opts.object = 'CrossEntropy';
rbm1 = pretrainRBM(rbm1, X, opts);
vishid = rbm1.W;
hidrecbiases = rbm1.b;
visbiases = rbm1.c;
X = v2h(rbm1, X);
batchposhidprobs2 = [];
for b=1:numbatches
  batchposhidprobs2(:,:,b) = X((1+(b-1)*numcases:b*numcases), :);
end;
save mnistvh vishid hidrecbiases visbiases;


fprintf(1,'\nPretraining Layer 2 with RBM: %d-%d \n',numhid,numpen);
batchdata=batchposhidprobs2;
numhid=numpen;
restart=1;
rbm;
hidpen=vishid; penrecbiases=hidbiases; hidgenbiases=visbiases;
save mnisthp hidpen penrecbiases hidgenbiases;

fprintf(1,'\nPretraining Layer 3 with RBM: %d-%d \n',numpen,numpen2);
batchdata=batchposhidprobs;
numhid=numpen2;
restart=1;
rbm;
hidpen2=vishid; penrecbiases2=hidbiases; hidgenbiases2=visbiases;
save mnisthp2 hidpen2 penrecbiases2 hidgenbiases2;

fprintf(1,'\nPretraining Layer 4 with RBM: %d-%d \n',numpen2,numopen);
batchdata=batchposhidprobs;
numhid=numopen; 
restart=1;
rbmhidlinear;
hidtop=vishid; toprecbiases=hidbiases; topgenbiases=visbiases;
save mnistpo hidtop toprecbiases topgenbiases;

backprop; 

