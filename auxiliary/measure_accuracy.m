function [ t_acc h_acc macro_F micro_F p_acc all_acc] = measure_accuracy( Y, Y_pred )

n=size(Y,1);
m=size(Y,2);

t_acc=0;
h_acc=0;

for i=1:n
    if(isequal(Y(i,:),Y_pred(i,:)))
        t_acc=t_acc+1;
    end
end
t_acc=t_acc/n;


for j=1:m
    h_acc=h_acc+length(find(Y(:,j)==Y_pred(:,j)));
end
h_acc=h_acc/(n*m);

%macro-F1
for j=1:m
    if(length(find(Y_pred(:,j)==1))==0)
        P(j)=1;
    else        
        P(j)=length(find(Y(:,j)==1 & Y_pred(:,j)==1))/length(find(Y_pred(:,j)==1));
    end
    if(length(find(Y(:,j)==1))==0)
        R(j)=1;
    else
        R(j)=length(find(Y(:,j)==1 & Y_pred(:,j)==1))/length(find(Y(:,j)==1));
    end
   
end

macro_P=mean(P);
macro_R=mean(R);

if(macro_P==0 & macro_R==0)
    macro_F=0;
else
    macro_F=(2*macro_P*macro_R)/(macro_P+macro_R);
end





%micro-F1
TP=0;
P_pred=0;
P_true=0;

for j=1:m
    TP=TP+length(find(Y(:,j)==1 & Y_pred(:,j)==1));
    P_pred=P_pred+length(find(Y_pred(:,j)==1));
    P_true=P_true+length(find(Y(:,j)==1));
end

if(P_pred==0)
    micro_P=1;
else
    micro_P=TP/P_pred;
end

micro_R=TP/P_true;


if(micro_P==0 & micro_R==0)
    micro_F=0;
else
    micro_F=(2*micro_P*micro_R)/(micro_P+micro_R);
end





%pairwise error
p_acc=0;
for i=1:m
    for j=i+1:m
        p_acc=p_acc+length(find(Y(:,i)==Y_pred(:,i) & Y(:,j)==Y_pred(:,j)));
    end
end
p_acc=p_acc/(n*nchoosek(m,2));

for i=1:m
   all_acc(i)=length(find(Y(:,i)==Y_pred(:,i)))/n; 
end
