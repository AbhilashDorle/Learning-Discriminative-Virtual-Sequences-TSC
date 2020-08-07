function [RVSML_dtw_acc_1] = Evaluate_ground_metric(lambda,templatenum,virtual_sequence,gamma,classnum,err,num)

options.max_iters = 200;
options.err_limit = err;


% Loading TRAIN data from the train function 
[trainset,trainsetdata,trainsetdatalabel,trainsetdatanum,trainsetnum]=train;
% disp(trainsetdatalabel);

%Loading TEST data from the test function
[testsetdata,testsetdatalabel,testsetdatanum]=test;

% trainset_m = trainset;
% testsetdata_m = testsetdata;
testsetlabel = testsetdatalabel;


tic;
% PARAMETER MATRIX
L = DVSL_dtw(trainset,templatenum,lambda,options,virtual_sequence,gamma,num);

DVSL_time = toc;

% CLASSIFICATION with the learned metric
traindownset = cell(1,classnum);
testdownsetdata = cell(1,testsetdatanum);

for j = 1:classnum
    traindownset{j} = cell(trainsetnum(j),1);
    for m = 1:trainsetnum(j)
        traindownset{j}{m} = trainset{j}{m} * L;
    end
end
for j = 1:testsetdatanum
    testdownsetdata{j} = testsetdata{j} * L;
end

%APPLYING NEAREST NEIGHBOR
[DVSL_acc,~] = NNClassifier_dtw(classnum,traindownset,trainsetnum,testdownsetdata,testsetdatanum,testsetlabel,options);
RVSML_dtw_acc_1 = DVSL_acc(1);

fprintf('Training time of RVSML instantiated by DTW is %.4f \n',DVSL_time);
fprintf('Accuracy is %.4f \n',RVSML_dtw_acc_1);
% disp('***************************************************');

end
