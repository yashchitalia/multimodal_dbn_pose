% Version 1.000
%
% Code provided by Yash Chitalia
% Randomizes input data first. 


rgborig = []; 
rgbocc = [];
docc = [];
dorig = [];
jointsorig = [];

rgb_train = []; %Data we will finally use for training (1000 occ + 200 orig)
rgb_test = []; %Data we will finally use to test(300 occ)

d_train = [];%Data we will finally use for training (1000 orig + 200 occ)
d_test = []; %Data we will finally use to test(300 occ)
targets_train = []; %Data we will finally use
targets_test = []; %Data we will finally use

load rgb_orig; rgborig = [rgborig; rgb_orig];
load rgb_occ; rgbocc = [rgbocc; rgb_occ];
load d_orig; dorig = [dorig; d_orig];
load d_occ; docc = [docc; d_occ];
load joints_orig; jointsorig = [jointsorig; joints_orig(:, 2:end)];

% rand('state',0); %so we know the permutation of the training data

% Adding random noise to the depth data
for i = 1:size(dorig, 1)
    I = reshape(dorig(i,:), [60, 90]);
    J = imnoise(I,'gaussian', 0.01);
    dorig(i, :) = reshape(J, [1, 60*90]);
end
for i = 1:size(docc, 1)
    I = reshape(docc(i,:), [60, 90]);
    J = imnoise(I,'gaussian', 0.01);
    docc(i, :) = reshape(J, [1, 60*90]);
end

randomtraintest=randperm(size(rgborig,1));
randomtrain_order = randomtraintest(1:19200);
randomtest_order = randomtraintest(19200:19800);

for b=1:9600
    rgb_train = [rgb_train; rgborig(randomtrain_order(b),:)];
    d_train = [d_train; dorig(randomtrain_order(b),:)];
    targets_train = [targets_train; jointsorig(randomtrain_order(b),:)];
end
for b=9601:19200
    rgb_train = [rgb_train; rgborig(randomtrain_order(b),:)];
    d_train = [d_train; dorig(randomtrain_order(b),:)];
    targets_train = [targets_train; jointsorig(randomtrain_order(b),:)];
end
% for b=1001:1200
%     rgb_train = [rgb_train; rgborig(randomtrain_order(b),:)];
%     d_train = [d_train; dorig(randomtrain_order(b),:)];
%     targets_train = [targets_train; jointsorig(randomtrain_order(b),:)];
% end


rgb_train = double(rgb_train)/255.0;
rgb_train = zscore(rgb_train);
d_train = double(d_train)/255.0;
d_train = zscore(d_train);

for b=1:300
    rgb_test = [rgb_test; rgbocc(randomtest_order(b),:)];
    d_test = [d_test; docc(randomtest_order(b),:)];
    targets_test = [targets_test; jointsorig(randomtest_order(b),:)];
end
for b=301:600
    rgb_test = [rgb_test; rgbocc(randomtest_order(b),:)];
    d_test = [d_test; docc(randomtest_order(b),:)];
    targets_test = [targets_test; jointsorig(randomtest_order(b),:)];
end

rgb_test = double(rgb_test)/255.0;
d_test = double(d_test)/255.0;
rgb_test_orig = rgb_test;
rgb_test = zscore(rgb_test);
d_test = zscore(d_test);


save prepped_data rgb_train rgb_test d_train d_test targets_train targets_test rgb_test_orig;
clear rgb_train rgb_test d_train d_test rgborig rgbocc dorig docc rgb_test_orig;

%%% Reset random seeds 
% rand('state',sum(100*clock)); 
% randn('state',sum(100*clock)); 



