function [PF, PD, area]=AUC(mask, E)
anomaly_map = logical(double(mask)>=1);
normal_map = logical(double(mask)==0);
r_max = max(E(:));
taus = linspace(0, r_max, 5000);
for index2 = 1:length(taus)
    tau = taus(index2);
    anomaly_map_rx = (E> tau);
    PF(index2) = sum(anomaly_map_rx & normal_map)/sum(normal_map);
    PD(index2) = sum(anomaly_map_rx & anomaly_map)/sum(anomaly_map);
end
area =  sum((PF(1:end-1)-PF(2:end)).*(PD(2:end)+PD(1:end-1))/2);
end