function [ P ] = interp_hermite( P )
    %INTERP standard RBF Interpolation
    
    disp(['------- Hermite - RBF Interpolation -------'])
    
    % compute distances
    if(P.kernel_aniso > 1)
        P.R = sqrt(sqdistance(P.Tp'));
    else
        P.R = sqrt(sqdistance(P.Xp'));
    end
    
    % get difference matrix
    P = diff_mat(P);
    

    % choose inversion method
    switch(P.kernel_inverse)
        case 1
            % estimate optimal eps
            disp(['# Optimizing Shape Parameter '])
            P.eps = fminbnd(@(ep) CostEps_hermite(ep,P),1e-3,1e0,optimset('Display','iter','TolX',1e-8));
             
            % normalize eps
            if(P.kernel_shape == 2)
                P.eps = P.eps./P.rcp;
            else
                P.eps = P.eps/mean(P.rcp);
            end
            
            % compute interpolation matrix 
            P.RBF_herm = rbf_hermite(P.R,P.eps,P.DM);
            
            % compute coefficients
            P.c_herm = P.RBF_herm\[P.F;P.DF(:)];

                
        case 2
            % estimate optimal eps
            P.eps = fminbnd(@(ep) CostEpsRiley(ep,P),1e-3/mean(P.rcp),1e1/mean(P.rcp));
            
            % normalize eps
            if(P.kernel_shape == 2)
                P.eps = P.eps./P.rcp;
            else
                P.eps = P.eps/mean(P.rcp);
            end
            
            % compute interpolation matrix 
            P.RBF = rbf(P.R,P.eps);
            
            % invert
            P.c = Riley_mex(P.RBF,P.F,P.riley_mu);
    end
    
            
    
end

