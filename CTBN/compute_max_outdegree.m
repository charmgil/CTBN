%sum the weight of outward links expect the ones going to the blacklist
function [ node ] = compute_max_outdegree( S, blacklist )

if(nargin<2)
    blacklist=[];
end

m=length(S);

%compute the outdegree for each node
for i=1:m
    if(~isempty(find(blacklist==i)))
        D(i)=-1;
    else
        D(i)=0;
        for q=1:m
            if(S{q}.from == i & isempty(find(blacklist==S{q}.to)))
                D(i)=D(i)+S{q}.weight;
            end
        end
    end
end

[D node]=max(D);


end

