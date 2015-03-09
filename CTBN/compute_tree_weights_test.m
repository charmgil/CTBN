function [ T ] = compute_tree_weights_test( T, X, Y )

for i=1:length(T)
    if mod(i,100) == 0
        fprintf('...%d', i);
    end
    %root
    if(isempty(T{i}.parent))
        node=T{i}.node;
        T{i}.weights=LR_train(X,Y(:,node),false);
    else
      
        node=T{i}.node;
        parent=T{i}.parent;
        T{i}.weights=LR_train([X Y(:,parent)],Y(:,node),false);
    end

end

fprintf('\n');


