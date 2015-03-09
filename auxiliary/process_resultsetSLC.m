function [SUMMARY] = process_resultset( RS )

if isfield(RS{1},'is_binary')
    if RS{1}.is_binary
        %disp('** not a probabilsitc model **');
    end
end

is_verbose = true;

R = length(RS);

acc = zeros(1, R);
acc_major = zeros(1, R);
acc_minor = zeros(1, R);
g = zeros(1, R);
f1 = zeros(1, R);
auc = zeros(1, R);
aucpr = zeros(1, R);
TP = zeros(1, R);
TN = zeros(1, R);
FP = zeros(1, R);
FN = zeros(1, R);
ppv = zeros(1, R);
npv = zeros(1, R);

for r = 1:R
    acc(r) = RS{r}.acc;
    acc_major(r) = RS{r}.acc_major;
    acc_minor(r) = RS{r}.acc_minor;
    g(r) = RS{r}.g;
    f1(r) = RS{r}.f1;
    auc(r) = RS{r}.auc;
    aucpr(r) = RS{r}.aucpr;
    
    TP(r) = RS{r}.conf_mat.TP;
    FP(r) = RS{r}.conf_mat.FP;
    TN(r) = RS{r}.conf_mat.TN;
    FN(r) = RS{r}.conf_mat.FN;
    if TP(r)+FP(r) == 0
        ppv(r) = 0;
    else
        ppv(r) = TP(r) / (TP(r)+FP(r));
    end
    if TN(r)+FN(r) == 0
        npv(r) = 0;
    else
        npv(r) = TN(r) / (TN(r)+FN(r));
    end
end

acc_mean = mean(acc);
acc_major_mean = mean(acc_major);
acc_minor_mean = mean(acc_minor);
g_mean = mean(g);
f1_mean = mean(f1);
auc_mean = mean(auc);
aucpr_mean = mean(aucpr);
ppv_mean = mean(ppv);
npv_mean = mean(npv);

acc_std = std(acc);
acc_major_std = std(acc_major);
acc_minor_std = std(acc_minor);
g_std = std(g);
f1_std = std(f1);
auc_std = std(auc);
aucpr_std = std(aucpr);
ppv_std = std(ppv);
npv_std = std(npv);

if is_verbose
    fprintf( 'acc \t\t= %f %c %f\n', acc_mean, char(177), acc_std );
    fprintf( 'acc_major \t= %f %c %f\n', acc_major_mean, char(177), acc_major_std );
    fprintf( 'acc_minor \t= %f %c %f\n', acc_minor_mean, char(177), acc_minor_std );
    fprintf( 'g-mean \t\t= %f %c %f\n', g_mean, char(177), g_std );
    fprintf( 'f-measure \t= %f %c %f\n', f1_mean, char(177), f1_std );
    fprintf( 'auc \t\t= %f %c %f\n', auc_mean, char(177), auc_std );
    fprintf( 'aucpr \t\t= %f %c %f\n', aucpr_mean, char(177), aucpr_std );
    fprintf( 'ppv \t\t= %f %c %f\n', ppv_mean, char(177), ppv_std );
    fprintf( 'npv \t\t= %f %c %f\n', npv_mean, char(177), npv_std );
end


SUMMARY.acc_mean = mean(acc);
SUMMARY.acc_major_mean = mean(acc_major);
SUMMARY.acc_minor_mean = mean(acc_minor);
SUMMARY.g_mean = mean(g);
SUMMARY.f1_mean = mean(f1);
SUMMARY.auc_mean = mean(auc);
SUMMARY.aucpr_mean = mean(aucpr);
SUMMARY.ppv_mean = mean(ppv);
SUMMARY.npv_mean = mean(npv);

SUMMARY.acc_std = std(acc);
SUMMARY.acc_major_std = std(acc_major);
SUMMARY.acc_minor_std = std(acc_minor);
SUMMARY.g_std = std(g);
SUMMARY.f1_std = std(f1);
SUMMARY.auc_std = std(auc);
SUMMARY.aucpr_std = std(aucpr);
SUMMARY.ppv_std = std(ppv);
SUMMARY.npv_std = std(npv);

end