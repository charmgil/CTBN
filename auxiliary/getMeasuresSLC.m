function RESULT = getMeasuresSLC(Y_true, Y_prob, Y_pred, is_plot)

if ~exist('is_plot','var')
    is_plot = false;
end

N = length(Y_true);
%thresh = .5;

neg = min(Y_true);
pos = max(Y_true);

if length(unique(Y_prob)) <= 2
    RESULT.is_binary = true;
else
    RESULT.is_binary = false;
end

%Y_pred = (Y_prob >= thresh);

% accuracy
RESULT.acc = sum(Y_true == Y_pred) / N;
RESULT.acc_major = sum(Y_true == Y_pred & Y_true == neg) / sum(Y_true == neg);  % TN/N = SPEC
RESULT.acc_minor = sum(Y_true == Y_pred & Y_true == pos) / sum(Y_true == pos);  % TP/P = SENS

% confusion matrix
conf_mat.TP = sum(Y_true == pos & Y_pred == pos);
conf_mat.FP = sum(Y_true == neg & Y_pred == pos);
conf_mat.TN = sum(Y_true == neg & Y_pred == neg);
conf_mat.FN = sum(Y_true == pos & Y_pred == neg);
RESULT.conf_mat = conf_mat;

% precision (PPV) and sensitivity (recall; TPR)
if conf_mat.TP == 0
    prec = 0;
    sens = 0;
else
    prec = conf_mat.TP / (conf_mat.TP + conf_mat.FP);
    sens = conf_mat.TP / (conf_mat.TP + conf_mat.FN);
end

% g-mean
RESULT.g = sqrt(prec*sens);

% f-measure (f1)
%beta = 1;
%f_beta = (1+beta^2)*prec*sens/(beta^2*prec+sens);
if prec+sens == 0
    RESULT.f1 = 0;
else
    RESULT.f1 = 2*prec*sens/(prec+sens);
end

% auc-roc
RESULT.auc = aucscore(Y_true, Y_prob, is_plot);

% auc-pr
RESULT.aucpr = aucprscore(Y_true, Y_prob, is_plot);

RESULT.Y_true = Y_true;
RESULT.Y_prob = Y_prob;

end