% This is an implmentation of the prediction algorithm presented in [Batal, Hong, Hauskrecht 2013]
%     I. Batal, C. Hong, and M. Hauskrecht. 
%     An efficient probabilistic framework for multi-dimensional classification.
%     CIKM 2013, Burlingame, CA, USA. October 2013.

function [ T ] = learn_output_tree( X, Y )

is_profiling = true;

[n m]=size(Y);

if is_profiling, t1 = clock; end;

%3-folds cross validation
k=3;
rand('seed',1);
indices = crossvalind('Kfold',Y(:,1),k);


idx=1;
idx2=1;
for i=1:m
    if mod(i, 100) == 0
        fprintf('...%d', i);
    end
    [ LL_without_Y ] = compute_crossvalidation_loglikelihood_test( X, Y(:,i), indices, k);
    S2{idx2}.from=i;
    S2{idx2}.weigth=LL_without_Y;
    idx2=idx2+1;
    
    for j=1:m 
        
        if(j ~= i)
             %measure the influence of Y_j on Y_i 
             [ LL_with_y ] = compute_crossvalidation_loglikelihood_test( [X Y(:,j)], Y(:,i), indices, k);
             
             %condition
             if(LL_with_y>LL_without_Y)
                 S{idx}.from=j;
                 S{idx}.to=i;
                % S{idx}.weight=LL_with_y-LL_without_Y;
                 S{idx}.weight=LL_with_y;
                 idx=idx+1;
             end
        end
    end


end

fprintf('\n');

if is_profiling, t2 = clock; end;

[ T ] = directed_maximum_spanning_tree( S );






if is_profiling, t3 = clock; end;

[ T ] = organize_tree_BFS( T );

if is_profiling, t4 = clock; end;

%T = compute_tree_weights_test(T, X_train, Y_train );

%LL=compute_loglikelihood(T, X_validation, Y_validation);
 
for q=1:k
        index_validation = find(indices==q);
        index_train = find(indices~=q); 
        X_validation= X(index_validation,:);
        Y_validation = Y(index_validation,:);
        X_train= X(index_train,:);
        Y_train = Y(index_train,:);
        T = compute_tree_weights_test(T, X_train, Y_train );

        LL(q)=compute_loglikelihood(T, X_validation, Y_validation);
end

mean(LL)

if is_profiling, t5 = clock; end;

if is_profiling,
    fprintf( '(pf)for-compute_edge_weight: %f s\n', etime(t2,t1) );
    fprintf( '(pf)directed_maximum_spanning_tree: %f s\n', etime(t3,t2) );
    fprintf( '(pf)organize_tree_BFS: %f s\n', etime(t4,t3) );
    fprintf( '(pf)compute_tree_weights: %f s\n', etime(t5,t4) );
end;
