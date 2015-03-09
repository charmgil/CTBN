function [ y_best y_best_prob ] = naive_MAP_inference_mc( T, Y )


Y_comb = generate_all_combinations(Y);

y_best=zeros(1,length(T));
max_log_prob=evaluate_probability( T,  y_best );

for i=2:size(Y_comb,1)
    [ log_prob ] = evaluate_probability( T,  Y_comb(i,:) );
    if(log_prob>max_log_prob)
        max_log_prob=log_prob;
        y_best=Y_comb(i,:);
    end
end

y_best_prob=exp(max_log_prob);