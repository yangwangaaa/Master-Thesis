function [ P ] = error_estim( P )
    %ERROR Summary of this function goes here
    %   Detailed explanation goes here
    
    %Ftrue = arrayfun(@(j) eval_llh(P.XX(j,:),P) , 1:P.NX)';
    
    disp(['------- Error Estimates -------'])
    
    Ftrue = zeros(P.NX,1);
    Fgradtrue = zeros(P.NX,P.pdim);
    if(P.kernel_aniso > 1)
        RR = sqrt(sqdistance((bsxfun(@minus,P.XX,P.Xmean)/P.M)',P.Tp'));
    else
        RR = sqrt(sqdistance(P.XX',P.Xp'));
    end
    
    for j = 1 : P.NX
        [Ftrue(j),Fgradtrue(j,:)] = eval_gradllh(P.XX(j,:),P);
    end
    P = gradllh(P);
    
    
    
    if(P.kernel_aniso > 1)
        Finterp = rbf(RR,P.eps)*P.c;
    else
        Finterp = rbf(RR,P.eps)*P.c;
    end
    
    P.inferror = max(abs(Ftrue-Finterp)/P.fmax);
    P.l1error = 1/P.NX*sum(abs(1-Ftrue./Finterp));

    A = rbf(P.R,P.eps);
    invA = pinv(A);
    EF = (invA*P.F)./diag(invA);

    figure(13)
    clf
    
    subplot(2,4,1)
    plot(log(Ftrue),log(abs(Ftrue-Finterp)/P.fmax),'r*')
    hold on
    error_ellipse(cov([log(Ftrue),log(abs(Ftrue-Finterp)/P.fmax)]),mean([log(Ftrue),log(abs(Ftrue-Finterp)/P.fmax)]))
    xlabel('log function value')
    ylabel('log rel MCMC error')
    
    subplot(2,4,5)
    plot(log(P.F),log(abs(EF)/P.fmax),'r*')
    hold on
    error_ellipse(cov([log(Ftrue),log(abs(Ftrue-Finterp)/P.fmax)]),mean([log(Ftrue),log(abs(Ftrue-Finterp)/P.fmax)]))
    xlabel('log function value')
    ylabel('log rel particle error')
    
    subplot(2,4,2)
    plot(log(sqrt(sum(Fgradtrue.^2,2))),log(abs(Ftrue-Finterp)/P.fmax),'r*')
    hold on
    error_ellipse(cov([log(sqrt(sum(Fgradtrue.^2,2))),log(abs(Ftrue-Finterp)/P.fmax)]),mean([log(sqrt(sum(Fgradtrue.^2,2))),log(abs(Ftrue-Finterp)/P.fmax)]))
    xlabel('log norm of gradient')
    ylabel('log rel MCMC error')
    
    subplot(2,4,6)
    plot(log(sqrt(sum(P.DF.^2,2))),log(abs(EF)/P.fmax),'r*')
    hold on
    error_ellipse(cov([log(sqrt(sum(Fgradtrue.^2,2))),log(abs(Ftrue-Finterp)/P.fmax)]),mean([log(sqrt(sum(Fgradtrue.^2,2))),log(abs(Ftrue-Finterp)/P.fmax)]))
    xlabel('log norm of gradient')
    ylabel('log rel particle error')
   
    subplot(2,4,3)
    plot(log(min(RR,[],2)),log(abs(Ftrue-Finterp)/P.fmax),'r*')
    hold on
    error_ellipse(cov([log(min(RR,[],2)),log(abs(Ftrue-Finterp)/P.fmax)]),mean([log(min(RR,[],2)),log(abs(Ftrue-Finterp)/P.fmax)]))
    xlabel('log min distance to grid')
    ylabel('log rel MCMC error')
    
    subplot(2,4,7)
    plot(log(min(P.R+max(max(P.R))*eye(P.N),[],2)),log(abs(EF)/P.fmax),'r*')
    hold on
    error_ellipse(cov([log(min(P.R+max(max(P.R))*eye(P.N),[],2)),log(abs(EF)/P.fmax)]),mean([log(min(P.R+max(max(P.R))*eye(P.N),[],2)),log(abs(EF)/P.fmax)]))
    xlabel('log min distance to grid')
    ylabel('log rel particle error') 
    

    
    try
        P.Nlist;
    catch
        P.Nlist = (P.R<min(repmat(P.rcp,1,P.N),repmat(P.rcp',P.N,1)))-logical(eye(P.N));
    end

    subplot(2,4,4)
    semilogy(sum(RR<P.D0*P.adap_rstar,2),log(abs(Ftrue-Finterp)/P.fmax),'r*')
    hold on
    error_ellipse(cov([sum(RR<P.D0*P.adap_rstar,2),log(abs(Ftrue-Finterp)/P.fmax)]),mean([sum(RR<P.D0*P.adap_rstar,2),log(abs(Ftrue-Finterp)/P.fmax)]))
    xlabel('Neighborhood size')
    ylabel('MCMC error')  
    
    subplot(2,4,8)
    semilogy(sum(P.Nlist,2),log(abs(EF)/P.fmax),'r*')
    hold on
    error_ellipse(cov([sum(P.Nlist,2),log(abs(EF)/P.fmax)]),mean([sum(P.Nlist,2),log(abs(EF)/P.fmax)]))
    xlabel('Neighborhood size')
    ylabel('log rel particle error')  

end

