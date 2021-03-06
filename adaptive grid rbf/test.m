
Ne=40;
Nt=2;
et=linspace(0,1,Nt);
ee=logspace(-1,0.5,Ne);

Ftrue = arrayfun(@(x,y,z) eval_llh([x y z],Ps),Ps.XX(:,1),Ps.XX(:,2),Ps.XX(:,3));


erf=zeros(Ne,1);
erf1=zeros(Ne,1);
erl=zeros(Ne,1);
erg=zeros(Ne,1);
econdest=zeros(Ne,1);
econd=zeros(Ne,1);
ercond=zeros(Ne,1);

Ps.kernel_shape = 1;


figure(11)
clf

if(Ps.kernel_aniso > 1)
    RR = sqrt(sqdistance(Ps.Tp'));
    RE = sqrt(sqdistance((bsxfun(@minus,Ps.XX,Ps.Xmean)/Ps.M)',Ps.Tp'));
else
    RR = sqrt(sqdistance(Ps.Xp'));
    RE = sqrt(sqdistance(Ps.XX',Ps.Xp'));
end

for k=1:Nt
    for j=1:Ne;
        if(Ps.kernel_shape == 2)
            Ps.eps = ee(j)./(Ps.rcp.^(et(k)));
        else
            Ps.eps = ee(j)/mean(Ps.rcp);
        end
        
        Ps.RBF = rbf(RR,Ps.eps);
        R_eval = rbf(RE,Ps.eps);

        Ps.c = Ps.RBF\Ps.F;
        
        Finterp = R_eval*Ps.c;
        erf(j)=max(abs(Ftrue-Finterp)/Ps.fmax);
        Ps.error_estim = 1;
        if(Ps.kernel_shape == 2)
            erl(j)=CostEps(ee(j).*Ps.rcp.^(1-et(k)),Ps)/Ps.fmax;
        else
            erl(j)=CostEps(ee(j),Ps)/Ps.fmax;
        end
        erg(j)=max(abs(Ps.F-Ps.RBF*Ps.c))/Ps.fmax;
        erf1(j)=norm(abs(Ftrue-Finterp),1)/Ps.fmax;
        econdest(j)=condest(Ps.RBF);
        ercond(j)=1/rcond(Ps.RBF);
        econd(j)=cond(Ps.RBF,inf);
    end
    % subplot(2,3,4)
    %
    %
    % subplot(2,3,[5 6])
    figure(11)
    subplot(1,Nt,k)
    semilogy(ee,erf,'.-k')
    hold on
    semilogy(ee,erf1,'--k')
    semilogy(ee,erl,'.-r')
    ylim([1e-5,1e0])
    title(['Exponent: ' num2str(et(k))])
    legend('rel. max error on extra grid','rel. l1 error on extra grid','rel. max error with Rippa Method','Location','SouthOutside')
    drawnow
end