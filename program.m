fprintf("Loading data...\n")
load('./Dall.mat');

param.L          = 50;           % not more than L non-zeros coefficients
param.eps        = 0;           % optional, threshold on the squared l2-norm of the residual, 0 by default
param.numThreads = -1;          % number of processors/cores to use; the default choice is -1 (it selects all the available CPUs/cores)

fprintf("Selecting train/test set...\n")
[train_set, test_set] = proyect_holdout(person, photo, patch, offset, 0, 10);
fprintf("Creating Y...\n")
[Y_holdout, person_holdout] = YfromD(Dall, test_set, person, photo);

fprintf("Creating sparse representation...\n")
D_holdout = Dall(:, train_set);
fprintf("Patience...\n")

X_holdout = full(mexOMP(Y_holdout,D_holdout,param));
X_holdout = X_holdout';

fprintf("Predicting person...\n")
prediction_holdout = predict_from_X(D_holdout, X_holdout, Y_holdout, person_holdout);

fprintf("Computing confusion matrix...\n")
Evaluate(person_holdout', prediction_holdout')
%plotconfusion(person_holdout, prediction_holdout);

