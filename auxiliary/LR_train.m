%learn_cost is a boolean variable, if false, do not optimize over for
%learning the cost, use the standard 1 cost (save time)
function [ weights ] = LR_train( X, Y, varargin )

global LR_implementation;

k=length(unique(Y))-1;

if isequal(LR_implementation,'weighted_liblinear')
    if(nargin<3)
        fprintf( 2, 'error: weight_vector is required @ LR_train.m' );
        return;
    elseif(nargin<4)
        learn_cost=true;
    else
        learn_cost=varargin{2};
    end;
    w = varargin{1};
    if(k>3), learn_cost=false; end;
else
    if(nargin<3)
        learn_cost=true;
    else
        learn_cost=varargin{1};
    end;
    if(k>2), learn_cost=false; end;
end


if(isequal(LR_implementation,'liblinear') || isequal(LR_implementation,'weighted_liblinear'))
    if(learn_cost)
        if isequal(LR_implementation,'liblinear')
            best_cost = choose_LR_cost( X, Y );
        elseif isequal(LR_implementation,'weighted_liblinear')
            best_cost = 1;%choose_LR_cost( X, Y, w );
            best_cost = best_cost * length(Y);
        end
    else
        best_cost=1;
    end
    param=[' -s 0 -B 1 -q -c ' num2str(best_cost)];
    if isequal(LR_implementation,'weighted_liblinear')
        M = train(w, Y, sparse(double(X)), param);
    else
        M = train(Y, sparse(double(X)),param);
    end
        
    weights=[];
    
    if size(M.w,1) == 1
        weights(1)=M.w(end);
        weights=[weights M.w(1:end-1)];
        %flip the weights
        if(M.Label(1)==0)
            weights=-weights;
        end
    else % size(M.w,1) > 1          % multi-class
%         weights(:,1) = M.w(:,end);
%         weights=[weights M.w(:,1:end-1)];
%         
%         %check label order
%         for i = 1:length(M.Label)
%             j = find(M.Label == i-1);
%             w_temp(i,:) = weights(j,:);
%         end
%         weights=w_temp;
        param=' -s 0 -B 1 -q -c 1';
        for i=0:k
            weights_temp=[];
            Y_binary=zeros(length(Y),1);
            Y_binary(find(Y==i))=1;
            
            if isequal(LR_implementation,'weighted_liblinear')
                M = train(w,Y_binary, sparse(double(X)),param);
            else
                M = train(Y_binary, sparse(double(X)),param);
            end
            
            weights_temp(1)=M.w(end);
            weights_temp=[weights_temp M.w(1:end-1)];
            if(M.Label(1)==0)
                weights_temp=-weights_temp;
            end
            weights(i+1,:)=weights_temp;
            
        end
        
    end
else
    weights = glmfit(X,[Y ones(length(Y),1)], 'binomial','link','logit');
end


end

