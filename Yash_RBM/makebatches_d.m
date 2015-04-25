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


dtrain=[]; 
targets=[]; 
load prepped_data; dtrain = [dtrain; d_train]; 
targets = [targets; targets_train]; 
totnum=size(dtrain,1);
fprintf(1, 'Size of the training dataset= %5d \n', totnum);

% rand('state',0); %so we know the permutation of the training data
randomorder=randperm(totnum);

numbatches=totnum/100;
numdims  =  size(dtrain,2);
batchsize = 100;
batchdata = zeros(batchsize, numdims, numbatches);
batchtargets = zeros(batchsize, 30, numbatches);

for b=1:numbatches
  batchdata(:,:,b) = dtrain(randomorder(1+(b-1)*batchsize:b*batchsize), :);
  batchtargets(:,:,b) = targets(randomorder(1+(b-1)*batchsize:b*batchsize), :);
end;

clear dtrain targets;

%%% Reset random seeds 
rand('state',sum(100*clock)); 
randn('state',sum(100*clock)); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%TEST STUFF%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dtest=[]; 
targets=[];
dtest = [dtest; d_test]; 
rgbvis = [];
rgbvis = [rgbvis; rgb_test_orig];
targets = [targets; targets_test]; 



totnum=size(dtest,1);
fprintf(1, 'Size of the test dataset= %5d \n', totnum);

rand('state',0); %so we know the permutation of the training data
randomorder=randperm(totnum);

numbatches=totnum/100;
numdims  =  size(dtest,2);
batchsize = 100;
testbatchdata = zeros(batchsize, numdims, numbatches);
testbatchtargets = zeros(batchsize, 30, numbatches);
visbatchdata = zeros(batchsize, numdims, numbatches);

for b=1:numbatches
  testbatchdata(:,:,b) = dtest(randomorder(1+(b-1)*batchsize:b*batchsize), :);
  visbatchdata(:,:,b) = rgbvis(randomorder(1+(b-1)*batchsize:b*batchsize), :);
  testbatchtargets(:,:,b) = targets(randomorder(1+(b-1)*batchsize:b*batchsize), :);
end;
clear rgbtest targets;
%%% Reset random seeds 
% rand('state',sum(100*clock)); 
% randn('state',sum(100*clock)); 


