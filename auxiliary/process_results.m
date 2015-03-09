function [ RS ] = process_results( Obj )

is_verbose = true;

for i=1:length(Obj)
    t_acc(i)=Obj{i}.ExactMatch;
    h_acc(i)=Obj{i}.HammingMatch;
    if(isfield(Obj{i},'ll'))
        ll(i)=Obj{i}.ll;
    else
        ll(i)=0;
    end
    micro_F(i)=Obj{i}.MicroF1;
    macro_F(i)=Obj{i}.MacroF1;
    ML_acc(i)=Obj{i}.Accuracy;
end

if is_verbose
    fprintf( 'EMA = %f %c %f\n', mean(t_acc), char(177), std(t_acc));
    fprintf( 'CLL_ts = %f %c %f\n', mean(ll), char(177), std(ll));
    fprintf( 'microF1 = %f %c %f\n', mean(micro_F), char(177), std(micro_F));
    fprintf( 'macroF1 = %f %c %f\n', mean(macro_F), char(177), std(macro_F));
    fprintf( 'Hamming = %f %c %f\n', mean(h_acc), char(177), std(h_acc));
    fprintf( 'ML.Acc = %f %c %f\n', mean(ML_acc), char(177), std(ML_acc));
%     fprintf( 'EMA/round = \n\t' );
%     fprintf( '%f    ', t_acc );
%     fprintf( '\n' );
end

RS.mean_t_acc = mean(t_acc);
RS.mean_ll = mean(ll);
RS.mean_micro_F = mean(micro_F);
RS.mean_macro_F = mean(macro_F);
RS.mean_h_acc = mean(h_acc);
RS.mean_ml_acc = mean(ML_acc);

RS.std_t_acc = std(t_acc);
RS.std_ll = std(ll);
RS.std_micro_F = std(micro_F);
RS.std_macro_F = std(macro_F);
RS.std_h_acc = std(h_acc);
RS.std_ml_acc = std(ML_acc);

end

