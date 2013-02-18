function [ ceps ] = CostEps( ep,P )
    %COSTEPS Summary of this function goes here
    %   Detailed explanation goes here
    
    if(P.kernel_shape == 2)
        ep = ep./P.rcp;
    else
        ep = ep/mean(P.rcp);
    end
    
    switch(P.error_estim)
        case 1        
            A = rbf(P.R,ep);
            % find solution of Ax=b and A^-1
            invA = pinv(A);
            EF = (invA*P.F)./diag(invA);
            ceps = norm(EF(:),inf);
        case 2
            A = rbf(P.R,ep);
            c = A\P.F;
            ceps = norm(P.F - A*c);
        case 3
            A = rbf(P.R,ep);
            ceps = rcond(A) + 1/eps*(rcond(A)<P.cond_tol*eps);
        case 4
            EF = zeros(P.N,1);
            for k=1:P.N
                A = rbf(P.R([1:k-1 k+1:end],[1:k-1 k+1:end]),ep);
                b = P.F([1:k-1 k+1:end]);
                n = P.N-1;
                cvx_begin
                     variable c(n)
                     minimize( norm(Ax - b,Inf) )
                     subject to 
                          0 <= c
                cvx_end
                if(P.kernel_aniso > 1)
                    EF(k) = abs(rbf(sqrt(sqdistance(P.Tp([1:k-1 k+1:end],:)',P.Tp(k,:))),ep)*c-P.F(k));
                else
                    EF(k) = abs(rbf(sqrt(sqdistance(P.Xp([1:k-1 k+1:end],:)',P.Xp(k,:))),ep)*c-P.F(k));
                end
            end
            
    end
end

