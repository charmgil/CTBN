% This is an implmentation of the prediction algorithm presented in [Batal, Hong, Hauskrecht 2013]
%     I. Batal, C. Hong, and M. Hauskrecht. 
%     An efficient probabilistic framework for multi-dimensional classification.
%     CIKM 2013, Burlingame, CA, USA. October 2013.


function [ Y_pred ] = MAP_prediction_naive( T, X )
for i=1:size(X,1)
    x=X(i,:);
    [ T ] = compute_log_potentials( T, x );
    Y_pred(i,:) = naive_MAP_inference( T );
end

