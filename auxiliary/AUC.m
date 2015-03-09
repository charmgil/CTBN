function [ area ] = AUC( x, y)
area=0;
for i=1:length(y)-1
    h=(y(i+1)+y(i))/2;
    w=abs(x(i+1)-x(i));
    area=area+h*w;
end
