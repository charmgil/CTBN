% This is an implementation of binary relevance [Clare and King 2001; Boutell et al 2004] 

%build a tree that corresponds to the independence model, each output is
%disconnected from the rest
function [ T ] = build_independent_tree(X, Y)

m=size(Y,2);

for i=1:m
    T{i}.node=i;
    T{i}.parent=[];
    T{i}.children=[];
end

[ T ] = compute_tree_weights(T, X, Y);