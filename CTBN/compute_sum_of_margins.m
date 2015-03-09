%predict the labels of X using model T, then compare with true labels Y
%some up the error margins
function [ prob_err total_err] = compute_sum_of_margins( T, X, Y)

prob_err=0;
total_err=0;
for i=1:size(X,1)
    x=X(i,:);
    [ T ] = compute_log_potentials( T, x );
    [Y_MAP log_prob_MAP]= maxsum_forest( T );
    if(~isequal(Y_MAP,Y(i,:)))
        log_prob_true = evaluate_probability( T,  Y(i,:) );
        prob_err=prob_err+exp(log_prob_MAP)-exp(log_prob_true);
        total_err=total_err+1;
    end    
end


end

