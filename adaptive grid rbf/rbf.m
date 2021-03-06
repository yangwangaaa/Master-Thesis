function D = rbf(r,eps)
%% Gaussian RBF

if numel(eps) == 1;
    eps=eps;
else 
    if size(eps,1)>size(eps,2)
        eps=eps';
    end
    eps=repmat(eps,size(r,1),1);
end

D = exp(-(eps.*r).^2);

%% MQ

%D = sqrt(1+(eps.*r).^2);

%% Wendland     

%D = max((1- eps.*r),0).^4;

end