function [E]=RCRDW(data1,  Dic1, lambda, gamma, tau,  dic_num)

Iteration=3;
[M, c] = size(data1);

for i = 1:M
    y=data1(i,:)';
    z=repmat(y,1,size(Dic1,2))-Dic1;
    v=sqrt(sum(z.^2));
    [~, lotion]=sort(v);
    Dic=Dic1(:, lotion(1:dic_num));
    %% Initialization
    ww=size(Dic, 2);
    weight=ones(1,c);
    weight_o=zeros(1,c);
    last=0;
    %% Initialization of alpha0
    for k=1:c
        %          k=1;
        Pk{k}=pinv(Dic(k, :)'*Dic(k, :)+eye(ww)*(lambda+tau*weight(k)));
        alpha0(:,k)=Pk{k}*Dic(k, :)'*y(k, :);
        last=last+weight(k)*alpha0(:,k);
    end
    alphak=alpha0;
    coef_m  =  last/sum(weight);
    iter = 0;
    Diff_w   = norm(weight-weight_o,2)./norm(weight_o,2);
    while Diff_w > 1e-3 && iter < Iteration
        %% update weight
        weight_o=weight;
        for k=1:c
            % k=1;
            weight(k)=exp(-1-tau*norm(alphak(:,k)-coef_m,2)^2/gamma);
        end
        last=0;
        last_new=0;
        Sum_inv =0;
        E_k=0;
        %% Update alpha0
        for k=1:c
            Pk{k}=pinv(Dic(k, :)'*Dic(k, :)+eye(ww)*(lambda+tau*weight(k)));
            alpha0(:,k)=Pk{k}*Dic(k, :)'*y(k, :);
            Sum_inv    = single(Sum_inv + tau*weight(k)^2*Pk{k}/sum(weight));
            last=last+weight(k)*alpha0(:,k);
        end
        %% Update alphak and compute residual
        Q=pinv(eye(ww)-Sum_inv);
        for k=1:c
            alphak(:,k)=alpha0(:,k)+tau*weight(k)/sum(weight)*Pk{k}*Q*last;
            E_k=E_k+weight(k)*norm((y(k,:)-single(Dic(k,:))*alphak(:,k)),2)^2;
            last_new=last_new+weight(k)*alphak(:,k);
        end
        coef_m  =  last_new/sum(weight);
        %% Computation of stopping criteria
        iter=iter+1;
        Diff_w   = norm(weight-weight_o,2)./norm(weight_o,2);
    end
    E(1,i)=E_k;
end
