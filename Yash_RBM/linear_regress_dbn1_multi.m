% Version 1.000
%
% Code provided by Ruslan Salakhutdinov and Geoff Hinton
% Modified by Yash Chitalia
% Permission is granted for anyone to copy, use, modify, or distribute this
% program and accompanying programs and documents for any purpose, provided
% this copyright notice is retained and prominently displayed, along with
% a note saying that the original programs are available from our
% web page.
% The programs and documents are distributed without any warranty, express or
% implied.  As the programs were written for research purposes only, they have
% not been tested to the degree that would be advisable in any important
% application.  All use of these programs is entirely at the user's own risk.

% This program perfroms linear regression with the outputs of the DBN layers

maxepoch=2;
fprintf(1,'\nApplies Linear Regression to the output of each batch. \n');
fprintf(1,'36 batches of 100 cases each. \n');

load mmdbn1vh_d
load mmdbn1vh_r
load mmdbn1po 

makebatches_d;
batchdata_d = batchdata;
testbatchdata_d = testbatchdata;
clear batchdata testbatchdata;
makebatches_rgb;
batchdata_r = batchdata;
testbatchdata_r = testbatchdata;
clear batchdata testbatchdata;
%%%% PREINITIALIZE WEIGHTS OF THE AUTOENCODER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
w1=[mm_vishid_d; mm_hidrecbiases_d];
w2=[mm_vishid_r; mm_hidrecbiases_r];
w3=[hidtop; toprecbiases];
%%%%%%%%%% END OF PREINITIALIZATIO OF WEIGHTS  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

l1=size(w1,1)-1;
l2=size(w2,1)-1;
l3=size(w3,1)-1;


test_err=[];
train_err=[];



%%%%%%%%%%%%%%%%%%%% COMPUTE TRAINING RECONSTRUCTION ERROR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
err=0; 
[numcases numdims numbatches]=size(batchdata_d);
N=numcases*numbatches;
dataout = [];
Y = [];
for batch = 1:numbatches
  data_d = [batchdata_d(:,:,batch)];
  data_d = bsxfun(@rdivide, data_d, rbm1.sig );
  data_d = [data_d ones(numcases,1)];
  data_r = [batchdata_r(:,:,batch)];
  data_r = bsxfun(@rdivide, data_r, rbm2.sig );
  data_r = [data_r ones(numcases,1)];
  w1probs = 1./(1 + exp(-data_d*w1)); 
  w2probs = 1./(1 + exp(-data_r*w2)); 
  w1w2probs = [w1probs w2probs ones(numcases,1)];
  dataout = [dataout; w1w2probs*w3];
  Y = [Y; batchtargets(:, :, batch)]; %This needs to be done since we shuffled the data
end
%%%%%%%%%%%%%% COMPUTE LINEAR REGRESSION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X1 = [ones(size(dataout, 1), 1) dataout]; %Input to Linear regression
B_est = X1\Y;                                % Estimate parameters
Yest = X1*B_est;
Yest(Yest<0) = 0;
Yest(Yest>1) = 1;

train_err = compute_error(Y, Yest);
%%%%%%%%%%%%%% END OF COMPUTING TRAINING RECONSTRUCTION ERROR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% COMPUTE TRAINING  ERROR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf(1,'Train squared error: %6.3f \t \t \n', train_err);
clear dataout data_d data_r N;
%%%%%%%%%%%%%%%%%%%% COMPUTE TEST RECONSTRUCTION ERROR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[testnumcases testnumdims testnumbatches]=size(testbatchdata_d);
N=testnumcases*testnumbatches;

Y_t = [];
dataout = [];
totaldata = [];
totaldata_orig = [];

for batch = 1:testnumbatches
  data_d = [testbatchdata_d(:,:,batch)];
  data_d = bsxfun(@rdivide, data_d, rbm1.sig );
  data_d = [data_d ones(numcases,1)];
  data_r = [testbatchdata_r(:,:,batch)];
  data_orig = [visbatchdata(:,:,batch)]; %Visualization
  data_r = bsxfun(@rdivide, data_r, rbm2.sig );
  data_r = [data_r ones(numcases,1)];
  w1probs = 1./(1 + exp(-data_d*w1)); 
  w2probs = 1./(1 + exp(-data_r*w2)); 
  w1w2probs = [w1probs w2probs ones(numcases,1)];
  dataout = [dataout; w1w2probs*w3];
  totaldata_orig = [totaldata_orig; data_orig];
  totaldata = [totaldata; data_r];

  Y_t = [Y_t; testbatchtargets(:,:,batch)];
end

%%%%%%%%%%%%%% COMPUTE LINEAR REGRESSION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X2 = [ones(size(dataout, 1), 1) dataout]; %Input to Linear regression
B_est_test = X2\Y_t;                                % Estimate parameters

Yt_est = X2*B_est;
Yt_est(Yt_est<0) = 0;
Yt_est(Yt_est>1) = 1;

test_err = compute_error(Y_t, Yt_est);

fprintf(1,'Train squared error: %6.3f Test squared error: %6.3f \t \t \n',train_err,test_err);
visualize_output(totaldata_orig,  Y_t);
visualize_output(totaldata(:,1:end-1),  Yt_est);

%%%%%%%%%%%%%%% END OF CONJUGATE GRADIENT WITH 3 LINESEARCHES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%







