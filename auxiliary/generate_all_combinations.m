%all binary combinations of size n
function [ C ] = generate_all_combinations( Y )

d=size(Y,2);


if(d==1)
    C=0:length(unique(Y(:,1)))-1;
end
    

if(d==2)
    S1=0:length(unique(Y(:,1)))-1;
    S2=0:length(unique(Y(:,2)))-1;
    
    sets = {S1, S2};
    [x y] = ndgrid(sets{:});
    C = [x(:) y(:)];
end

if(d==3)
    S1=0:length(unique(Y(:,1)))-1;
    S2=0:length(unique(Y(:,2)))-1;
    S3=0:length(unique(Y(:,3)))-1;
    
    sets = {S1, S2, S3};
    [x y z] = ndgrid(sets{:});
    C = [x(:) y(:) z(:)];
end

if(d==4)
    S1=0:length(unique(Y(:,1)))-1;
    S2=0:length(unique(Y(:,2)))-1;
    S3=0:length(unique(Y(:,3)))-1;
    S4=0:length(unique(Y(:,4)))-1;
    
    sets = {S1, S2, S3, S4};
    
    [x y z a] = ndgrid(sets{:});
    C = [x(:) y(:) z(:) a(:)];
end

if(d==5)
    S1=0:length(unique(Y(:,1)))-1;
    S2=0:length(unique(Y(:,2)))-1;
    S3=0:length(unique(Y(:,3)))-1;
    S4=0:length(unique(Y(:,4)))-1;
    S5=0:length(unique(Y(:,5)))-1;
    
    sets = {S1, S2, S3, S4, S5};
    
    [x y z a b] = ndgrid(sets{:});
    C = [x(:) y(:) z(:) a(:) b(:)];
end


if(d==6)
    S1=0:length(unique(Y(:,1)))-1;
    S2=0:length(unique(Y(:,2)))-1;
    S3=0:length(unique(Y(:,3)))-1;
    S4=0:length(unique(Y(:,4)))-1;
    S5=0:length(unique(Y(:,5)))-1;
    S6=0:length(unique(Y(:,6)))-1;
    
    sets = {S1, S2, S3, S4, S5, S6};
    
    [x y z a b c] = ndgrid(sets{:});
    C = [x(:) y(:) z(:) a(:) b(:) c(:)];
end

end


