function [PF, PD, area]=AUC(mask, E)
[PD,PF,~] = roc(mask,E);
area =  abs(sum((PF(1:end-1)-PF(2:end)).*(PD(2:end)+PD(1:end-1))/2));
end
