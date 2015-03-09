% This is an implmentation of the prediction algorithm presented in [Batal, Hong, Hauskrecht 2013]
%     I. Batal, C. Hong, and M. Hauskrecht. 
%     An efficient probabilistic framework for multi-dimensional classification.
%     CIKM 2013, Burlingame, CA, USA. October 2013.

function [ Y_pred Y_log_prob] = MAP_prediction_sw( T, X, Y )

is_profiling = false;

% check if multi-class
is_multiclass = false;
for i=1:length(T)
    if isfield(T{i}, 'weights2')
        is_multiclass = true;
        break;
    end
    
    if isfield(T{i}, 'weights')
        [r,c]=size(T{i}.weights);
        if min(r,c) > 1
            is_multiclass = true;
            break;
        end
    else 
        if isfield(T{i}, 'weights0')
            [r,c]=size(T{i}.weights0);
            if min(r,c) > 1
                is_multiclass = true;
                break;
            end
        end
        if isfield(T{i}, 'weights1')
            [r,c]=size(T{i}.weights0);
            if min(r,c) > 1
                is_multiclass = true;
                break;
            end
        end
        if isfield(T{i}, 'weights2')
            [r,c]=size(T{i}.weights0);
            if min(r,c) > 1
                is_multiclass = true;
                break;
            end
        end
    end
end

if is_profiling, pf_comp = 0; pf_maxsum = 0; end;

for i=1:size(X,1)
    x=X(i,:);
    t1 = clock;
    [ T ] = compute_log_potentials_sw( T, x );
    t2 = clock;
    if is_multiclass
        Y_pred(i,:) = naive_MAP_inference_mc(T, Y );
    else
        Y_pred(i,:) = maxsum_forest( T );
    end
    t3 = clock;
    
    if is_profiling
        pf_comp = pf_comp + etime(t2,t1);
        pf_maxsum = pf_maxsum + etime(t3,t2);
    end
    
    Y_log_prob(i)=evaluate_probability( T,  Y(i,:) );
end

if is_profiling
    fprintf( '(pf)for-compute_log_potentials: %f s\n', pf_comp );
    fprintf( '(pf)for-maxsum_forest: %f s\n', pf_maxsum );
end