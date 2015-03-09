function [ Obj ] = convert_to_new_format( t_acc, h_acc, macro_F, micro_F, LL )

Obj.ExactMatch=t_acc;
Obj.HammingMatch=h_acc;
Obj.MacroF1=macro_F;
Obj.MicroF1=micro_F;
Obj.ll=LL;

end

