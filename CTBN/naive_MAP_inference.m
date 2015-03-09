function [ y_best y_best_prob ] = naive_MAP_inference( T )


%charmgil commented - 7/10%[ Y ] = generate_all_combinations( T );
Y = generate_all_bin_combinations(length(T));

y_best=zeros(1,length(T));
max_log_prob=evaluate_probability( T,  y_best );

for i=2:size(Y,1)
    [ log_prob ] = evaluate_probability( T,  Y(i,:) );
    if(log_prob>max_log_prob)
        max_log_prob=log_prob;
        y_best=Y(i,:);
    end
end

y_best_prob=exp(max_log_prob);