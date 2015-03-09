function [ T ] = compute_log_potentials( T, x )

for i=1:length(T)
    if(isempty(T{i}.parent))
        p= LR_predict( T{i}.weights,x );
        if(length(p)==1)
            T{i}.log_potential(1)=log(1-p);
            T{i}.log_potential(2)=log(p);
        else
            T{i}.log_potential(1)=log(p(1));
            T{i}.log_potential(2)=log(p(2));
            T{i}.log_potential(3)=log(p(3));
        end
    else
        %conditional
        %parent is zero
        p= LR_predict( T{i}.weights,[x 0]);
        if(length(p)==1)
            T{i}.log_potential(1,1)=log(1-p);
            T{i}.log_potential(1,2)=log(p); 
        else
            T{i}.log_potential(1,1)=log(p(1));
            T{i}.log_potential(1,2)=log(p(2));
            T{i}.log_potential(1,3)=log(p(3));
        end
                
        %parent is one
        p= LR_predict( T{i}.weights,[x 1]);
        if(length(p)==1)
            T{i}.log_potential(2,1)=log(1-p);
            T{i}.log_potential(2,2)=log(p); 
        else
            T{i}.log_potential(2,1)=log(p(1));
            T{i}.log_potential(2,2)=log(p(2));
            T{i}.log_potential(2,3)=log(p(3));
        end
    end

end

