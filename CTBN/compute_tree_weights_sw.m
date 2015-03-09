function [ T ] = compute_tree_weights_sw( T, X, Y, varargin )

global LR_implementation;

if nargin > 3
    w = varargin{1};
elseif isequal(LR_implementation,'weighted_liblinear')
    fprintf( 'error: weight_vector is required @ compute_tree_weights.m\n' );
end

for i=1:length(T)
    if mod(i,100) == 0
        fprintf('...%d', i);
    end
    T{i}.card=length(unique(Y(:,T{i}.node)));
    %root
    if(isempty(T{i}.parent))
        node=T{i}.node;
        if isequal(LR_implementation,'weighted_liblinear')
            T{i}.weights=LR_train(X,Y(:,node), w);
        else
            T{i}.weights=LR_train(X,Y(:,node));
        end
    else
        node=T{i}.node;
        parent=T{i}.parent;
        
        no_instance0 = false;
        no_instance1 = false;
        no_instance2 = false;
        
        %parent==0
        roi = (Y(:,parent)==0);
        if sum(roi) > 3
            if isequal(LR_implementation,'weighted_liblinear')
                T{i}.weights0=LR_train(X(roi,:),Y(roi,node), w(roi));
            else
                T{i}.weights0=LR_train(X(roi,:),Y(roi,node));
            end
        else
            no_instance0 = true;
        end
        %parent==1
        roi = (Y(:,parent)==1);
        if sum(roi) > 3
            if isequal(LR_implementation,'weighted_liblinear')
                T{i}.weights1=LR_train(X(roi,:),Y(roi,node), w(roi));
            else
                T{i}.weights1=LR_train(X(roi,:),Y(roi,node));
            end
        else
            no_instance1 = true;
        end
        %parent==2
        roi = (Y(:,parent)==2);
        if sum(roi) > 3
            if isequal(LR_implementation,'weighted_liblinear')
                T{i}.weights2=LR_train(X(roi,:),Y(roi,node), w(roi));
            else
                T{i}.weights2=LR_train(X(roi,:),Y(roi,node));
            end
        else
            no_instance2 = true;
        end
        
        
        if no_instance0
            T{i}.weights0 = T{i}.weights1;
        elseif no_instance1
            T{i}.weights1 = T{i}.weights0;
        end
        % uncertainty check
        if length(unique(Y(:,parent))) > 2 && (no_instance0||no_instance1||no_instance2)
            % uncertainty arises: this scope shouldn't be triggered
            fprintf( 2, 'error: incorrect result is being produced! (compute_tree_weights_sw.m)\n' );
        end
        
%        fprintf( '[node:%d |parent:%d -- #0=%d, #1=%d]\n', ...
%            node, parent, length(Y(:,parent)==0), length(Y(:,parent)==1) );
    end

end

%fprintf('\n');


