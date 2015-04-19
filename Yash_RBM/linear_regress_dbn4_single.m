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
fprintf(1,'12 batches of 100 cases each. \n');

load dbn4vh
load dbn4hp
load dbn4hp2
load dbn4po 

makebatches;
[numcases numdims numbatches]=size(batchdata);
N=numcases; 

%%%% PREINITIALIZE WEIGHTS OF THE AUTOENCODER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
w1=[vishid; hidrecbiases];
w2=[hidpen; penrecbiases];
w3=[hidpen2; penrecbiases2];
w4=[hidtop; toprecbiases];
%%%%%%%%%% END OF PREINITIALIZATIO OF WEIGHTS  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

l1=size(w1,1)-1;
l2=size(w2,1)-1;
l3=size(w3,1)-1;
l4=size(w4,1)-1;

test_err=[];
train_err=[];



%%%%%%%%%%%%%%%%%%%% COMPUTE TRAINING RECONSTRUCTION ERROR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
err=0; 
[numcases numdims numbatches]=size(batchdata);
N=numcases;
dataout = [];
Y = [];
for batch = 1:numbatches
  data = [batchdata(:,:,batch)];
  data = [data ones(N,1)];
  w1probs = 1./(1 + exp(-data*w1)); w1probs = [w1probs  ones(N,1)];
  w2probs = 1./(1 + exp(-w1probs*w2)); w2probs = [w2probs ones(N,1)];
  w3probs = 1./(1 + exp(-w2probs*w3)); w3probs = [w3probs  ones(N,1)];
  dataout = [dataout; w3probs*w4];
  Y = [Y; batchtargets(:, :, batch)]; %This needs to be done since we shuffled the data
end
%%%%%%%%%%%%%% COMPUTE LINEAR REGRESSION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X1 = [ones(size(dataout, 1)) dataout]; %Input to Linear regression
B_est = X1\Y;                                % Estimate parameters

train_err = 1/N*sum(sum( (Y-X1*B_est).^2 ));
%%%%%%%%%%%%%% END OF COMPUTING TRAINING RECONSTRUCTION ERROR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% COMPUTE TRAINING  ERROR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf(1,'Train squared error: %6.3f \t \t \n', train_err);

%%%%%%%%%%%%%%%%%%%% COMPUTE TEST RECONSTRUCTION ERROR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [testnumcases testnumdims testnumbatches]=size(testbatchdata);
% N=testnumcases;
% err=0;
% for batch = 1:testnumbatches
%   data = [testbatchdata(:,:,batch)];
%   data = [data ones(N,1)];
%   w1probs = 1./(1 + exp(-data*w1)); w1probs = [w1probs  ones(N,1)];
%   w2probs = 1./(1 + exp(-w1probs*w2)); w2probs = [w2probs ones(N,1)];
%   w3probs = 1./(1 + exp(-w2probs*w3)); w3probs = [w3probs  ones(N,1)];
%   w4probs = w3probs*w4; w4probs = [w4probs  ones(N,1)];
%   w5probs = 1./(1 + exp(-w4probs*w5)); w5probs = [w5probs  ones(N,1)];
%   w6probs = 1./(1 + exp(-w5probs*w6)); w6probs = [w6probs  ones(N,1)];
%   w7probs = 1./(1 + exp(-w6probs*w7)); w7probs = [w7probs  ones(N,1)];
%   dataout = 1./(1 + exp(-w7probs*w8));
%   err = err +  1/N*sum(sum( (data(:,1:end-1)-dataout).^2 ));
%   end
%  test_err(epoch)=err/testnumbatches;
%  fprintf(1,'Before epoch %d Train squared error: %6.3f Test squared error: %6.3f \t \t \n',epoch,train_err(epoch),test_err(epoch));
% 


%%%%%%%%%%%%%%% END OF CONJUGATE GRADIENT WITH 3 LINESEARCHES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%







