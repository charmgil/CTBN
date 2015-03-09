%compute the conditional influence of Y_input on Y_output
function [ edge_weight ] = compute_edge_weight( X, Y_input, Y_output)

%internal-cross validation

%use 1/3 of the data for validation
k=3;
%rand('seed',1);
indices = crossvalind('Kfold',Y_output,k);
%save time
learn_cost=false;

for i=1:k
    index_validation = find(indices==i);
    index_train = find(indices~=i); 

    Y_train=Y_output(index_train);
    Y_validation = Y_output(index_validation);

    %the model based on X only
    X_train1=X(index_train,:);
    X_validation1= X(index_validation,:);
    [ W1 ] = LR_train( X_train1, Y_train, learn_cost );
    P1=LR_predict( W1,X_validation1 );
    LL1(i) = LR_likelihood( P1, Y_validation );

    %the model based on X and Y_input
    X_train2=[X(index_train,:) Y_input(index_train,:)];
    X_validation2= [X(index_validation,:) Y_input(index_validation,:)];

    [ W2 ] = LR_train( X_train2, Y_train, learn_cost );
    P2=LR_predict( W2,X_validation2 );
    LL2(i) = LR_likelihood( P2, Y_validation );

end

%if LL2 is less than LL1, weight = 0
if(mean(LL2)<mean(LL1))
    edge_weight=0;
%weight is log(P(D|M2)|P(D|M1))
else
    edge_weight=mean(LL2)-mean(LL1);
end
    