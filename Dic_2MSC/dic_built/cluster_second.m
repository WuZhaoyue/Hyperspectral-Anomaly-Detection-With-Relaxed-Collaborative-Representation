function class_dic=cluster_second(data1,data_num,clustMembsCell1,bandwidth2)
%% second clustering to remove weak anomalies and select dictionary atoms
class_dic=[];

for i=1: size(clustMembsCell1, 1);
    subclass_data=data1(clustMembsCell1{i},:);
    [clustCent2,point2cluster,clustMembsCell2] = HGMeanShiftCluster(subclass_data',bandwidth2,'gaussian');
    numClust2 = length(clustMembsCell2);
    data_num2=[];
    for k=1:numClust2
        data_num2(1, k)=size(clustMembsCell2{k}, 2);
    end
    anoL=find(data_num2<=ceil(data_num(1,i)*0.001));% remove abnormal edge points of first clustering
    data_num2(anoL)=[];
    clustMembsCell2(anoL)=[];
    clustCent2(:,anoL)=[];
    
    % select representative background pixels
    for j=1:size(clustMembsCell2,1)
        cent2=repmat(clustCent2(:,j),1, data_num2(1, j));
        distance2=sqrt(sum((cent2-subclass_data(clustMembsCell2{j,1},:)').^2, 1));
        [~, index2]=sort(distance2);
        clect2=clustMembsCell2{j, 1}(1, index2(1:1));
        class_dic=[class_dic subclass_data(clect2,:)'];
    end
end