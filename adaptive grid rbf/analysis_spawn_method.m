clear all

vN = [1 2];
NN = 2;
Nrepeat = 20;


for j = 1:NN
    for k = 1:Nrepeat
        disp(['j: ' num2str(j) ' / ' num2str(NN)])
        disp(['k: ' num2str(k) ' / ' num2str(Nrepeat)])
        load init_latt
        P.Riter = 0;
        
        P.adap_D0 = 0.8;
        P.adap_d0 = P.adap_D0/1.2;
        
        P.init_D0 = 0.8;
        P.init_d0 = P.adap_D0/1.2;
        
        P.d0 = P.init_d0;
        P.D0 = P.init_D0;
        P.plotflag=false;
        P.adap_spawn_method = vN(j);
        
        Ps = P;
        Ps = refine_particles( Ps );
        mIter(j,k) = Ps.Riter;
        mN(j,k) = Ps.N;
        Ps = interp(Ps);
        
        if(Ps.kernel_aniso > 1)
            RR = sqrt(sqdistance((bsxfun(@minus,Ps.XX,Ps.Xmean)/Ps.M)',Ps.Tp'));
        else
            RR = sqrt(sqdistance(Ps.XX',Ps.Xp'));
        end
        
        if(P.kernel_aniso > 1)
            Finterp = rbf(RR,Ps.eps)*Ps.c;
        else
            Finterp = rbf(RR,Ps.eps)*Ps.c;
        end
        
        ml2err(j,k) = 1/Ps.NX*sum(abs(Ps.Ftrue - Finterp).^2./Ps.Ftrue);
        mlinferr(j,k) = max(abs(Ps.Ftrue - Finterp));
        
        mfuse(j,k) = sum(Ps.kfuse);
        mspawn(j,k) = sum(Ps.kspawn);
        
    end
end


str = {'original','modified'};

figure(80)
clf
boxplot(mlinferr',str)
ylabel('$$\log(L_{\infty}\mbox{-error})$$','Interpreter','LaTex')
axis square
set(gcf, 'Color', 'w')

figure(81)
clf
boxplot(mN',str)
ylabel('\# Points')
axis square
set(gcf, 'Color', 'w')

figure(82)
clf
boxplot(ml2err',str)
ylabel('$$L_2\mbox{-error}$$','Interpreter','LaTex')
axis square
set(gcf, 'Color', 'w')

figure(83)
clf
boxplot(mspawn',str)
ylabel('Total number of spawned particles')
axis square
set(gcf, 'Color', 'w')

figure(84)
clf
boxplot(mfuse',str)
ylabel('Total number of fused particles')
axis square
set(gcf, 'Color', 'w')

figure(85)
clf
boxplot(mIter',str)
ylabel('\# Iterations')
axis square
set(gcf, 'Color', 'w')

save([datestr(clock) '_analysis_spawn_method'])
