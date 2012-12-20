function [ P ] = spawn_particles( P )
    %NEW_PARTICLES Inserts new particles where neighborhood is too small
    %   Detailed explanation goes here
    P.R = distm_mex(P.Xp,P.Xp);
    P.Nlist = (P.R<min(repmat(P.rcp,1,P.N),repmat(P.rcp',P.N,1)));
    ind = find(P.adap_Nstar-sum(P.Nlist)>0);
    for l=ind
        if(P.F(l)>P.fmax*P.thresh)
            Nfill=P.adap_Nstar-sum(distm_mex(P.Xp(l,:),P.Xp)<min(P.rcp,P.rcp(l))');
            for j=1:Nfill
                % wiki n-sphere
%                 plot(P.Xp(l,1),P.Xp(l,2),'co')
%                 circle(P.Xp(l,1),P.Xp(l,2),P.Dp(l)/2);
%                 circle(P.Xp(l,1),P.Xp(l,2),P.rcp(l));
%                 hold on
                xnew = randn(1,size(P.Xp,2));
                % normalize & make sure we do not insert points inside the cutoff radii ...
                %xnew = (((rstar-1/2)*rand(1)+1/2)*Dp(l))*xnew/norm(xnew)+Xp(l,:);
                xnew = P.Dp(l)*xnew/norm(xnew)+P.Xp(l,:);
                P.Xp = [P.Xp; xnew];
                P.Dp(end+1) = P.Dp(l);
                P.F(end+1) = eval_llh(xnew,P);
                P.rcp(end+1) = P.adap_rstar*P.Dp(end);
%                 plot(xnew(1),xnew(2),'go')
                P.N=P.N+1;
            end
            if(size(P.rcp,2)>size(P.rcp,1))
                P.rcp=P.rcp';
            end
        end
    end
    drawnow
end

