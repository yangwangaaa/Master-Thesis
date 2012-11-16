function D = drbf(r,eps,dx)
%% Gaussian RBF

%D = bsxfun(@times,exp(-(eps*r).^2)*(-2*(eps)^2),dx);

%% MQ RBF

D = bsxfun(@times,eps^2./sqrt(1+(eps*r).^2),dx);

end