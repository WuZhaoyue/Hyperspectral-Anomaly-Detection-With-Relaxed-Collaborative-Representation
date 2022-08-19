function [Dic, CenterClust]=Dic_built(data1,bandwidth1, bandwidth2 )
%% first clustering
[M, ~]=size(data1);
[CenterClust,~,clustMembsCell1] = HGMeanShiftCluster(data1',bandwidth1,'gaussian');

% remove significant abnormal pixels
numClust1 = length(clustMembsCell1);
data_num=zeros(1, numClust1);
% clust_map=zeros(M,1);
for k=1:numClust1
    data_num(1, k)=size(clustMembsCell1{k}, 2);
    % clust_map(clustMembsCell1{k})=k;
end
anoL=find(data_num<ceil(M*0.001));% remove isolated points
data_num(anoL)=[];
clustMembsCell1(anoL)=[];
if size(data_num, 2)>1 % remove abnormal cluster
    [~, minL]=min(data_num);
    clustMembsCell1(minL)=[];
    data_num(minL)=[];
end

%% second clustering
Dic=cluster_second(data1,data_num,clustMembsCell1,bandwidth2);

% %% calculate weight matrix W
% W=zeros(size(Dic, 2),M);
% for i=1:M
%     %     i=1;
%     test_pixel=repmat(data1(i,:)', 1,size(Dic, 2));
%     %     distance=(test_pixel-Dic);
%     distance=(test_pixel-Dic).^2+1e-20;
%     W(:,i)=sqrt(sum(distance, 1));
% end
