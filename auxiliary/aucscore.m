% fnorm Calculates the aucscore.
% usage auc = aucscore(y, ypred, plot)
% y is the actual values and ypred the predicted ones. 
% if plot is true a graph with auc will be ploted. default is 0
% positive labels are 1 and negative 0.
function auc = aucscore(y, y_pred, is_plot)
if (~exist('is_plot', 'var') || isempty(is_plot))
is_plot = 0;
end

% force each row to be an instance
if (size(y, 2) ~= 1)
    y = y';
    y_pred = y_pred';
end

[~,ind] = sort(y_pred,'descend'); 
roc_y = y(ind);
stack_x = cumsum(roc_y == 0)/sum(roc_y == 0);
stack_y = cumsum(roc_y == 1)/sum(roc_y == 1);
auc = sum((stack_x(2:length(roc_y),1)-stack_x(1:length(roc_y)-1,1)).*stack_y(2:length(roc_y),1));
% if auc < .5
%     auc = 1 - auc;
% end

if (is_plot)
    figure;
    hold on;
    plot(stack_x, stack_y);
    xlabel('False Positive Rate');
    ylabel('True Positive Rate');
    title(['ROC curve of (AUC = ' num2str(auc) ' )']);
    hold off;
end
end

