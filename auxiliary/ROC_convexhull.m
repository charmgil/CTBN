%take FP and TP of ROC and return the points for convex hull 
function [ x2 y2] = ROC_convexhull( x , y)

%didn't converge properly
if(length(x)==2)
    x2=x;
    y2=y;
    return
end


x(x==NaN) = .001;x(x==Inf) = .99;
y(y==NaN) = .001;y(y==Inf) = .99;

[K, a] = convhull(x,y);

A=[x' y'];

B = maxYtoX(A(K,:));
x2=B(:,1);
y2=B(:,2);
