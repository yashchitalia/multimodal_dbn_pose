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
r_batchdata = zeros(batchsize, numdims, numbatches);
batchtargets = zeros(batchsize, 30, numbatches);

for b=1:numbatches
  r_batchdata(:,:,b) = rgbtrain(randomorder(1+(b-1)*batchsize:b*batchsize), :);
  r_batchtargets(:,:,b) = targets(randomorder(1+(b-1)*batchsize:b*batchsize), :);
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
r_testbatchdata = zeros(batchsize, numdims, numbatches);
r_testbatchtargets = zeros(batchsize, 30, numbatches);

for b=1:numbatches
  r_testbatchdata(:,:,b) = rgbtest(randomorder(1+(b-1)*batchsize:b*batchsize), :);
  r_testbatchtargets(:,:,b) = targets(randomorder(1+(b-1)*batchsize:b*batchsize), :);
end;
clear rgbtest targets;
%%% Reset random seeds 
rand('state',sum(100*clock)); 
randn('state',sum(100*clock)); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


dtrain=[]; 
targets=[]; 
load prepped_data; dtrain = [dtrain; d_train]; 
targets = [targets; targets_train]; 

totnum=size(dtrain,1);
fprintf(1, 'Size of the training dataset= %5d \n', totnum);

rand('state',0); %so we know the permutation of the training data
randomorder=randperm(totnum);

numbatches=totnum/100;
numdims  =  size(dtrain,2);
batchsize = 100;
d_batchdata = zeros(batchsize, numdims, numbatches);
d_batchtargets = zeros(batchsize, 30, numbatches);

for b=1:numbatches
  d_batchdata(:,:,b) = dtrain(randomorder(1+(b-1)*batchsize:b*batchsize), :);
  d_batchtargets(:,:,b) = targets(randomorder(1+(b-1)*batchsize:b*batchsize), :);
end;
clear dtrain targets;

%%% Reset random seeds 
rand('state',sum(100*clock)); 
randn('state',sum(100*clock)); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%TEST STUFF%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dtest=[]; 
targets=[];
dtest = [dtest; d_test]; 
targets = [targets; targets_test]; 



totnum=size(dtest,1);
fprintf(1, 'Size of the test dataset= %5d \n', totnum);

rand('state',0); %so we know the permutation of the training data
randomorder=randperm(totnum);

numbatches=totnum/100;
numdims  =  size(dtest,2);
batchsize = 100;
d_testbatchdata = zeros(batchsize, numdims, numbatches);
d_testbatchtargets = zeros(batchsize, 30, numbatches);

for b=1:numbatches
  d_testbatchdata(:,:,b) = dtest(randomorder(1+(b-1)*batchsize:b*batchsize), :);
  d_testbatchtargets(:,:,b) = targets(randomorder(1+(b-1)*batchsize:b*batchsize), :);
end;
clear dtest targets;
%%% Reset random seeds 
rand('state',sum(100*clock)); 
randn('state',sum(100*clock)); 
