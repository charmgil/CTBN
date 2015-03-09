function [ Y_pred Y_log_prob] = MAP_prediction( T, X, Y )

is_profiling = true;

if is_profiling, pf_comp = 0; pf_maxsum = 0; end;

for i=1:size(X,1)
    x=X(i,:);
    t1 = clock;
    [ T ] = compute_log_potentials( T, x );
    save( 'T', 'T' );
    t2 = clock;
     Y_pred(i,:) = maxsum_forest( T );
    t3 = clock;
    
    pf_comp = pf_comp + etime(t2,t1);
    pf_maxsum = pf_maxsum + etime(t3,t2);
    
    Y_log_prob(i)=evaluate_probability( T,  Y(i,:) );
end

if is_profiling
    fprintf( '(pf)for-compute_log_potentials: %f s\n', pf_comp );
    fprintf( '(pf)for-maxsum_forest: %f s\n', pf_maxsum );
end