function [data, data_o, data2D, data2D_o, M,  m, n,b, mask]=load_data(data_number)
switch data_number
    case 1
        load 'dataPavia'
        data_o=PaviaCenter;
        data=PaviaCenter;
        [data2D, data2D_o, M,m, n,b, data]=generalization(data);
        load 'maskPavia'
        mask = reshape(mask, 1, M);
end
end
    function [data2D, data2D_o, M,m, n,b, data]=generalization(data)
        [m, n, b]=size(data);
        M=m*n;
        data2D_o=reshape(data, M, b);
        for i=1:b
            sub_data=data(:,:,i);
            data(:,:,i)= (sub_data-min(sub_data(:)))./(max(sub_data(:))-min(sub_data(:)));
        end
        data2D=reshape(data, M, b);
    end

