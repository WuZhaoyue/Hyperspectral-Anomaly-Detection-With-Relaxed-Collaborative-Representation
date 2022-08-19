function [E]=RCRD(data1,  Dic1, lambda, tau, dic_num)

[M, c] = size(data1);

for i = 1:M
    y=data1(i,:)';
    z=repmat(y,1,size(Dic1,2))-Dic1;
    v=sqrt(sum(z.^2));
    [~, lotion]=sort(v);
    Dic=Dic1(:, lotion(1:dic_num)); % select dic_num optimal atoms from "Dic" for each pixel
   %% Initialization
    ww=size(Dic, 2);
    weight=ones(1,c);
    Sum_inv =0;
    last=0;
    E_k=0;
   %% Initialization of alpha0
    for k=1:c
        % k=1;
        Pk{k}=pinv(Dic(k, :)'*Dic(k, :)+eye(ww)*(lambda+tau*weight(k)));
        alpha0(:,k)=Pk{k}*Dic(k, :)'*y(k, :);
        Sum_inv = single(Sum_inv + tau*weight(k)^2*Pk{k}/sum(weight));
        last=last+weight(k)*alpha0(:,k);
    end
    
    Q=pinv(eye(ww)-Sum_inv);
   %% Update alphak and compute residual
    for k=1:c
        alphak(:,k)=alpha0(:,k)+tau*weight(k)/sum(weight)*Pk{k}*Q*last;
        E_k=E_k+weight(k)*norm((y(k,:)-single(Dic(k,:))*alphak(:,k)),2)^2;
    end
    
    E(1,i)=E_k;
end
