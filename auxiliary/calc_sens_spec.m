function [err, sen, spec, conf_matrix] = confusion_matrix(C_pred,C)

%the multiclasses case
%u = unique(pred_y);
%conf_matrix = zeros(numel(u));
%for i=1:length(u)
%   for j=1:length(u)
%      conf_matrix(i,j) = length(find(pred_y == u(j) & true_y == u(i)));
%   end
%end
%err=1-sum(diag(conf_matrix))/length(true_y);

if(size(C_pred,1) ~= size(C,1))
    C_pred=C_pred';
end
%only two classes (0:neg or 1:pos)
TP=length(find(C_pred== 1 & C == 1));
TN=length(find(C_pred== 2 & C == 2));
FP=length(find(C_pred== 1 & C == 2));
FN=length(find(C_pred== 2 & C == 1));

sen=TP/(TP+FN);
spec=TN/(FP+TN);
err=(FP+FN)/(TP+TN+FP+FN);

conf_matrix(1,1)=TP;
conf_matrix(1,2)=FP;
conf_matrix(2,1)=FN;
conf_matrix(2,2)=TN;

