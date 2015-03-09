function [ C ] = get_children( S, n, blacklist)

if(nargin<3)
    blacklist=[];
end

C=[];
for i=1:length(S)
    if(S{i}.from==n & isempty(find(blacklist==i)))
        C=[C S{i}.to];
    end


end

