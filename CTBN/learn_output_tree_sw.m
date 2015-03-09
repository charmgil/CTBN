% This is an implmentation of the prediction algorithm presented in [Batal, Hong, Hauskrecht 2013]
%     I. Batal, C. Hong, and M. Hauskrecht. 
%     An efficient probabilistic framework for multi-dimensional classification.
%     CIKM 2013, Burlingame, CA, USA. October 2013.

function [ T ] = learn_output_tree_sw( X, Y )

is_profiling = false;

[n m]=size(Y);

if is_profiling, t1 = clock; end;

%3-folds cross validation
k=3;
%rand('seed',1);
indices = crossvalind('Kfold',Y(:,1),k);


idx=1;
for i=1:m
    if mod(i, 10) == 0
        fprintf('...%d', i);
    end
    [ LL_without_Y ] = compute_crossvalidation_loglikelihood( X, Y(:,i), indices, k);
    node_weights(i)=LL_without_Y;
    for j=1:m 
        
        if(j ~= i)
             %measure the influence of Y_j on Y_i 
                %[ LL_with_y ] = compute_crossvalidation_loglikelihood( [X Y(:,j)], Y(:,i), indices, k);
             [ LL_with_y ] = compute_crossvalidation_loglikelihood_sw( X, Y(:,i), Y(:,j), indices, k);
             %condition
             if(LL_with_y>LL_without_Y)
                 S{idx}.from=j;
                 S{idx}.to=i;
                 %S{idx}.weight=LL_with_y-LL_without_Y;
                 S{idx}.weight=LL_with_y;
                 idx=idx+1;
             end
        end
    end


end

%fprintf('\n');

if is_profiling, t2 = clock; end;

for i=1:m
    
    [ T_list{i} T_weight(i)] = directed_maximum_spanning_tree( S,1:m,i,node_weights );
end

[max_weight max_idx]=max(T_weight);

T=T_list{max_idx};

if is_profiling, t3 = clock; end;

[ T ] = organize_tree_BFS( T );

if is_profiling, t4 = clock; end;

T = compute_tree_weights_sw(T, X, Y );

if is_profiling, t5 = clock; end;

if is_profiling,
    fprintf( '(pf)for-compute_edge_weight: %f s\n', etime(t2,t1) );
    fprintf( '(pf)directed_maximum_spanning_tree: %f s\n', etime(t3,t2) );
    fprintf( '(pf)organize_tree_BFS: %f s\n', etime(t4,t3) );
    fprintf( '(pf)compute_tree_weights: %f s\n', etime(t5,t4) );
end;
