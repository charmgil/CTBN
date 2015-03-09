%give the projections and compute the ROC
%return 1-spec and sens
function [ auc x y] = compute_ROC( proj, C_pred, C_test )

 thresholds=unique(sort(proj));
 thresholds=[-10000; thresholds];

 %specify the direction of the test
 %if b=1, then predict class 1 if projection is bigger than threshold
 if( (proj(1)>0 && C_pred(1)==1) || (proj(1)<=0 && C_pred(1)==2) )
    b=1;
 else
    b=0;
 end

 for t=1:length(thresholds)
     alpha=thresholds(t);
     if(b)
        C_pred(find(proj>alpha))=1;
        C_pred(find(proj<=alpha))=2;
     else
        C_pred(find(proj>alpha))=2;
        C_pred(find(proj<=alpha))=1;
     end
     [t1, sen, spec, t2] = calc_sens_spec(C_pred,C_test);
     x(t)=1-spec;
     y(t)=sen;

 end
[x_conv y_conv]=ROC_convexhull(x,y);
auc=AUC(x_conv,y_conv);