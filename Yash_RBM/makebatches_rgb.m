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
% Code modified for pose estimation autoencoders by Yash Chitalia


rgbtrain=[]; 
targets=[]; 
load prepped_data; rgbtrain = [rgbtrain; rgb_train]; 
targets = [targets; targets_train]; 

totnum=size(rgbtrain,1);
fprintf(1, 'Size of the training dataset= %5d \n', totnum);

rand('state',0); %so we know the permutation of the training data
randomorder=randperm(totnum);

numbatches=totnum/100;
numdims  =  size(rgbtrain,2);
batchsize = 100;
batchdata = zeros(batchsize, numdims, numbatches);
batchtargets = zeros(batchsize, 30, numbatches);

for b=1:numbatches
  batchdata(:,:,b) = rgbtrain(randomorder(1+(b-1)*batchsize:b*batchsize), :);
  batchtargets(:,:,b) = targets(randomorder(1+(b-1)*batchsize:b*batchsize), :);
end;
clear rgbtrain targets;

%%% Reset random seeds 
rand('state',sum(100*clock)); 
randn('state',sum(100*clock)); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%TEST STUFF%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rgbtest=[]; 
targets=[];
rgbtest = [rgbtest; rgb_test]; 
targets = [targets; targets_test]; 



totnum=size(rgbtest,1);
fprintf(1, 'Size of the test dataset= %5d \n', totnum);

rand('state',0); %so we know the permutation of the training data
randomorder=randperm(totnum);

numbatches=totnum/100;
numdims  =  size(rgbtest,2);
batchsize = 100;
testbatchdata = zeros(batchsize, numdims, numbatches);
testbatchtargets = zeros(batchsize, 30, numbatches);

for b=1:numbatches
  testbatchdata(:,:,b) = rgbtest(randomorder(1+(b-1)*batchsize:b*batchsize), :);
  testbatchtargets(:,:,b) = targets(randomorder(1+(b-1)*batchsize:b*batchsize), :);
end;
clear rgbtest targets;
%%% Reset random seeds 
rand('state',sum(100*clock)); 
randn('state',sum(100*clock)); 


