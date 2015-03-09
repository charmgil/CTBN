function [ P ] = get_parent( S, n)

P=[];
for i=1:length(S)
    if(S{i}.to==n )
        P=S{i}.from;
        return
    end

end

