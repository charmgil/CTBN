function [ T ] = compute_tree_weights( T, X, Y, varargin )

global LR_implementation;

if nargin > 3
    w = varargin{1};
elseif isequal(LR_implementation,'weighted_liblinear')
    fprintf( 'error: weight_vector is required @ compute_tree_weights.m\n' );
end

for i=1:length(T)
    T{i}.card=length(unique(Y(:,T{i}.node)));

    if mod(i,100) == 0
        fprintf('...%d', i);
    end
    %root
    if(isempty(T{i}.parent))
        node=T{i}.node;
        if isequal(LR_implementation,'weighted_liblinear')
            T{i}.weights=LR_train(X, Y(:,node), w);
        else
            T{i}.weights=LR_train(X, Y(:,node));
        end
    else
      
        node=T{i}.node;
        parent=T{i}.parent;
        if isequal(LR_implementation,'weighted_liblinear')
            T{i}.weights=LR_train([X Y(:,parent)], Y(:,node), w);
        else
            T{i}.weights=LR_train([X Y(:,parent)], Y(:,node));
        end
    end

end

%fprintf('\n');


