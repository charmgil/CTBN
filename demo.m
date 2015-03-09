clear;clc;

% path
addpath('auxiliary');
addpath('CTBN');
addpath('liblinear-1.92/matlab');

% init
global LR_implementation;
global learn_LR_cost;
LR_implementation = 'liblinear';  % designate the library to use (for logistic regression)
learn_LR_cost = false;    % if true, it learns the regularization coefficient on the fly

% sample run
dataset_name = 'emotions';
load(['data/' dataset_name '.mat']);

fprintf('[Training & testing CTBN on ''%s'']\n', dataset_name);

% 10-fold cv
K = 10;
CVO = cvpartition(Y(:,1), 'kfold', K);

CTBN = cell(1, K);
Y_pred_CTBN = cell(1, K);
Y_log_prob_CTBN = cell(1, K);

for r = 1:CVO.NumTestSets
    fprintf('msg: round %d/%d... ', r, CVO.NumTestSets);
    tic;
    X_tr = X(CVO.training(r), :);
    Y_tr = Y(CVO.training(r), :);
    
    X_ts = X(CVO.test(r), :);
    Y_ts = Y(CVO.test(r), :);
    
    % CTBN [Batal, Hong, Hauskrecht 2013]
    
    % train
    s1 = clock;
    CTBN_model = learn_output_tree_sw(X_tr, Y_tr);
    
    % test
    s2 = clock;
    [ Y_pred_CTBN{r}, Y_log_prob_CTBN{r}] = MAP_prediction_sw(CTBN_model, X_ts, Y_ts);
    t = clock;
    toc;
    
    % bookkeeping
    CTBN{r} = getMeasuresMLC(Y_ts, Y_pred_CTBN{r}, Y_log_prob_CTBN{r});
end

% report results
fprintf('\n[Test results on ''%s'']\n', dataset_name);
process_results(CTBN);

