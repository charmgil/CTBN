function [ Y_pred ] = inference_marginal_all( T, X )

% is_profiling?
is_profiling = true;
if is_profiling, pf_comp = 0; pf_infer = 0; end;

% is_switching?
is_switching = false;
for i = 1:length(T)
    if isfield(T{i}, 'weights1')
        is_switching = true;
        break;
    end
end

% inference on each label
for i=1:size(X,1)
    x=X(i,:);
    t1 = clock;
    
    if is_switching
        [ T ] = compute_log_potentials_sw( T, x );
    else
        [ T ] = compute_log_potentials( T, x );
    end
    
    save( 'T', 'T' );
    t2 = clock;
    for j=1:length(T)
        %fprintf( 'Y%d:', j );
        tmp = inference( T, j );
        Y_pred(i,j) = tmp{1}(2);
    end
    t3 = clock;
    
    pf_comp = pf_comp + etime(t2,t1);
    pf_infer = pf_infer + etime(t3,t2);
end

% report profiles
if is_profiling
    fprintf( '(pf)for-compute_log_potentials: %f s\n', pf_comp );
    fprintf( '(pf)for-inference_all: %f s\n', pf_infer );
end