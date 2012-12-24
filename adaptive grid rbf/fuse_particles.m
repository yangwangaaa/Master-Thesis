function [ P ] = fuse_particles( P )
    %FUSE_PARTICLES fuse particles where |xp_xq|<Dpq/2
    % do this in a greedy-type fashion by removing particles with most points inside the cutoff radius first
    P.kfuse(P.Riter)=0;
    if(P.kernel_aniso == 3)
        P.R = distm_mex(P.Tp,P.Tp);
    else
        P.R = distm_mex(P.Xp,P.Xp);
    end
    P.Dpq = bsxfun(@min,P.Dp,P.Dp');
    ii = sparse(P.R<P.Dpq/2-eye(P.N));
    [row,col] = find(ii);
    ti = row(row>col);
    P.Dp(ti)=[];
    P.Xp(ti,:)=[];
    if(P.kernel_aniso == 3)
        P.Tp(ti,:)=[];
    end
    P.F(ti)=[];
    P.Lp(ti)=[];
    P.rcp(ti)=[];
    P.kfuse(P.Riter)=P.N-size(P.Xp,1);
    P.N=size(P.Xp,1);
    
%     while(true)
%         [s,ind] = max();
%         if(s==1)
%             P.rcp = P.adap_rstar*P.Dp;
%             break
%         else
%             P.Dp=P.Dp([1:ind-1 ind+1:end]);
%             P.Xp=P.Xp([1:ind-1 ind+1:end],:);
%             if(P.kernel_aniso == 3)
%                 P.Tp=P.Tp([1:ind-1 ind+1:end],:);
%             end
%             P.F=P.F([1:ind-1 ind+1:end]);
%             P.Lp=P.Lp([1:ind-1 ind+1:end]);
%             P.rcp = P.adap_rstar*P.Dp;
%             ii=ii([1:ind-1 ind+1:end],[1:ind-1 ind+1:end]);
%             P.kfuse(P.Riter)=P.kfuse(P.Riter)+1;
%             P.N=P.N-1;
%         end
%     end
end

