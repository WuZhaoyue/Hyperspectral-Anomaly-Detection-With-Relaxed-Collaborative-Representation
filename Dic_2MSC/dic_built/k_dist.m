function k_dist(A, k)
numData=size(A, 1);

Kdist=zeros(numData,1);
[~,Dist]=knnsearch(A(2:numData,:),A(1,:), 'K', k);
Kdist(1)=Dist(k);
% Kdist2(1)=Dist(k2);

for i=2:size(A,1)
    [~,Dist] = knnsearch(A([1:i-1,i+1:numData],:),A(i,:), 'K', k);
    Kdist(i)=Dist(k);
end

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
% axis([0 13000 0 6.2])
grid on;

