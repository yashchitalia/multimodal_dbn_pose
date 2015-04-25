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

% This program perfroms linear regression with the outputs of the DBN layers

maxepoch=2;
fprintf(1,'\nApplies Linear Regression to the output of each batch. \n');
fprintf(1,'Batches of 100 cases each. \n');

load dbn1vh_d


makebatches_d;
%makebatches_rgb;

[numcases numdims numbatches]=size(batchdata);
N=numcases; 

%%%% PREINITIALIZE WEIGHTS OF THE AUTOENCODER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
w1=[vishid; hidrecbiases];
%%%%%%%%%% END OF PREINITIALIZATIO OF WEIGHTS  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

l1=size(w1,1)-1;

%%%%%%%%%%%%%%%%%%%% COMPUTE TRAINING RECONSTRUCTION ERROR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
err=0; 
[numcases numdims numbatches]=size(batchdata);
N=numcases*numbatches;
dataout = [];
Y = [];
totaldata = [];

for batch = 1:numbatches
  data = [batchdata(:,:,batch)];
  data = bsxfun(@rdivide, data, rbm1.sig );
  data = [data ones(numcases,1)];
  dataout = [dataout; 1./(1 + exp(-data*w1))]; 
  totaldata = [totaldata; data];
  Y = [Y; batchtargets(:, :, batch)]; %This needs to be done since we shuffled the data
end
%%%%%%%%%%%%%% COMPUTE LINEAR REGRESSION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X1 = [ones(size(dataout, 1),1) dataout]; %Input to Linear regression
B_est = X1\Y;                                % Estimate parameters
Yest = X1*B_est;
Yest(Yest<0) = 0;
Yest(Yest>1) = 1;
train_err = compute_error(Y, Yest);


%%%%%%%%%%%%%% END OF COMPUTING TRAINING RECONSTRUCTION ERROR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% COMPUTE TRAINING  ERROR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf(1,'Train squared error: %6.3f \t \t \n', train_err);
clear dataout data N totaldata;
%%%%%%%%%%%%%%%%%%%% COMPUTE TEST RECONSTRUCTION ERROR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[testnumcases testnumdims testnumbatches]=size(testbatchdata);
N=testnumcases*testnumbatches;

Y_t = [];
dataout = [];
totaldata = [];
totaldata_orig = [];
for batch = 1:testnumbatches
  data = [testbatchdata(:,:,batch)];
  data_orig = [visbatchdata(:,:,batch)];
  data = bsxfun(@rdivide, data, rbm1.sig );
  data = [data ones(testnumcases,1)];
  dataout = [dataout; 1./(1 + exp(-data*w1))];
  totaldata = [totaldata; data];
  totaldata_orig = [totaldata_orig; data_orig];
  Y_t = [Y_t; testbatchtargets(:,:,batch)];
end
%%%%%%%%%%%%%% COMPUTE LINEAR REGRESSION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X2 = [ones(size(dataout, 1), 1) dataout]; %Input to Linear regression
B_est_test = X2\Y_t;                                % Estimate parameters

Yt_est = X2*B_est;
Yt_est(Yt_est<0) = 0;
Yt_est(Yt_est>1) = 1;
test_err = compute_error(Y_t, Yt_est);



visualize_output(totaldata_orig,  Y_t);
visualize_output(totaldata(:,1:end-1),  Yt_est);

fprintf(1,'Train squared error: %6.3f Test squared error: %6.3f \t \t \n',train_err,test_err);





%%%%%%%%%%%%%%% END OF CONJUGATE GRADIENT WITH 3 LINESEARCHES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%







