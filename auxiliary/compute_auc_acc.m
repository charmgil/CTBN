function [ auc, auc2, acc ] = compute_auc_acc( Y_true, Y_pred )

[ n, d ] = size( Y_true );

auc = zeros(1,d);
auc2 = zeros(1,d);
%auc3 = zeros(1,d);
acc = zeros(1,d);


for j = 1:d
    auc(j) = aucscore( Y_true(:,j), Y_pred(:,j) );
    acc(j) = mean( Y_true(:,j) == round(Y_pred(:,j)) );
    auc2(j) = scoreAUC( Y_true(:,j), Y_pred(:,j) );
    %auc3(j) = compute_ROC( Y_pred(:,j), round(Y_pred(:,j)), Y_true(:,j));
end

