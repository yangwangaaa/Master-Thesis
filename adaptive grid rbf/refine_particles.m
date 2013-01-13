function [ P ] = refine_particles( P )
    %REFINE_PARTICLES Summary of this function goes here
    %   Detailed explanation goes here
    P.Riter = 1;

    P.NI = [];
    P.CI = [];
    P.PI = [];
    P.XI = [];
    P.Lh = [];
    P.W = [];
    
    while(true)
        
        ind = P.F > P.fmax*P.rem_thresh;
        P.kthresh(P.Riter)=P.N-sum(ind);
        P.F = P.F(ind);
        P.Xp = P.Xp(ind,:);
        if(P.kernel_aniso > 1)
            P.Tp = P.Tp(ind,:);
        end
        P.Dp = P.Dp(ind);
        P.Lp = P.Lp(ind);
        P.rcp = P.rcp(ind);
        P.N = size(P.Xp,1);
        
        P = fuse_particles( P );
        
        P = exactDp( P );
        
        P = spawn_particles( P );
        
        P = exactDp( P );
        
        if(P.Riter>P.adap_gradient_start)
            for s=1:P.adap_ngradstep
                P = gradient_step( P );
            end
            P.Dpq = bsxfun(@min,P.Dp,P.Dp');
            P.W2(P.Riter) = sum(sum(P.Dpq.^2*V1_mex(P.R./P.Dpq)));
        else
            if(P.kernel_aniso > 1)
                P.cDp = TriScatteredInterp(P.Tp,P.Dp);
                P.cDpNN = TriScatteredInterp(P.Tp,P.Dp,'nearest');
            else
                P.cDp = TriScatteredInterp(P.Xp,P.Dp);
                P.cDpNN = TriScatteredInterp(P.Xp,P.Dp,'nearest');
            end
            P.wp = zeros(P.N,P.pdim);
            P.W(P.Riter) = OrgEnergy(P,0);
        end
        
        if(P.kernel_aniso > 1 && mod(P.Riter,P.cov_iter)==0)
            P = TptoXp(P);
            P = calc_transform(P);
            P = XptoTp(P);
        end
        P = llh(P);
        
        P = exactDp(P);
        
        if(P.kernel_aniso > 1)
            P.R = distm_mex(P.Tp,P.Tp);
        else
            P.R = distm_mex(P.Xp,P.Xp);
        end
        P.Dpq = bsxfun(@min,P.Dp,P.Dp');
        
        P.crit = P.Dpq./P.R;
        P.Nlist = (P.R<min(repmat(P.rcp,1,P.N),repmat(P.rcp',P.N,1)))-logical(eye(P.N));
        
        P.NI(P.Riter) = sum(sum(P.Nlist(P.F>P.fmax*P.thresh,:),2)<P.adap_Nstar-1);
        P.CI(P.Riter) = max([max(P.crit(logical(P.Nlist))),0]);
        P.PI(P.Riter) = sum(P.F>P.fmax*P.thresh);
        P.XI(P.Riter) = P.N;
        P.Lp = P.Lp+ones(size(P.Lp));
        P.Lh = [P.Lh,zeros(size(P.Lh,1),max(size(hist(P.Lp,1:max(P.Lp)),2)-size(P.Lh,2),0));hist(P.Lp,1:max(P.Lp))/P.N,zeros(1,max(size(P.Lh,2)-size(hist(P.Lp,1:max(P.Lp)),2),0))];
        
        
        if(mod(P.Riter,P.plotinter)==0 && P.plotflag)
            switch(P.pdim)
                case 2
                    plot_points2( P , 1 )
                case 3
                    plot_points3( P , 1 )
            end
        end
        
        if(sum(sum(P.Nlist(P.F>P.fmax*P.thresh,:),2)<P.adap_Nstar-1)==0 && max([max(P.crit(logical(P.Nlist))),0])<=P.adap_dc)
            break;
        end
        P.Riter = P.Riter+1;
    end
    
end
