function k_dist(A, k)

numData=size(A, 1);
dist = pdist2(A,A);
kMatrix=sort(dist, 'ascend');
Kdist=kMatrix(k,:);
[sortKdist,~]=sort(Kdist,'descend');

distX=(1:numData)';
figure
plot(distX,sortKdist,'r+-','LineWidth',1);
text1=xlabel('pixels','FontSize',13,'Vertical','middle','FontName','Times New Roman'); 
text=ylabel('k-distance','FontSize',13,'Vertical','middle','FontName','Times New Roman');
set(text,'Units','Normalized','Position',[-0.13,0.5,0]);
set(text1,'Units','Normalized','Position',[0.5,-0.12,0]);
set(gcf,'position',[100 100 300 300]); 
set (gca,'position',[0.13 0.14 0.81 0.82]);
grid on;
