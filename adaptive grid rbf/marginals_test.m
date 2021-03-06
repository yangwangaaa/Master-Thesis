function marginals_test( P )
    %MARGINALS Takes problem P and plots the marginals for the rbf approximate
    warning( 'off' , 'MATLAB:legend:IgnoringExtraEntries')
    disp(['------- Computing Marginals -------'])
    
    figure(32)
    clf
    
    if(P.kernel_aniso > 1)
        Integral = sum(P.c.*sqrt(pi./P.eps.^4).^P.pdim)/abs(det(P.M));
    else
        Integral = sum(P.c.*sqrt(pi./P.eps.^4).^P.pdim);
    end
    
    NV = 100;
    
    SIGMA=P.M*P.M;
    
%     if(P.pdim==2)
%         xx = linspace(min(P.Xp(:,1)),max(P.Xp(:,1)),NV);
%         yy = linspace(min(P.Xp(:,2)),max(P.Xp(:,2)),NV);
%         [XX,YY] = meshgrid(xx,yy);   
%         X = [XX(:),YY(:)];
%         F = arrayfun(@(x,y) eval_llh([x y],P),X(:,1),X(:,2));
%         FF = reshape(F,size(XX));
%         nummargin(1,:) = 1/(xx(2)-xx(1))*trapz(FF,1)/Integral;
%         nummargin(2,:) = 1/(yy(2)-yy(1))*trapz(FF,2)/Integral;
%     end
    
    
    for j=1:P.pdim
        for k=1:P.pdim
            subplot(P.pdim,P.pdim,(j-1)*P.pdim+k)
            if(j==k)
                % 1D
                
                % evaluation points
                xx = linspace(P.paramspec{j}{3},P.paramspec{j}{4},NV)';
                % distances
                rr = sqrt(sqdistance(xx',P.Xp(:,j)'));
                % sigma
                sigma = sqrt(SIGMA(j,j));
                % evaluate rbf
                yy = 1/(sigma/P.eps*sqrt(pi))*rbf(rr,P.eps/sigma)*P.c/abs(sum(P.c));
                plot(xx,yy,'r-')
                hold on
                % kde 
                [~,kdedens,kdexx]=kde(P.mcchain(:,j),NV,P.paramspec{j}{3},P.paramspec{j}{4});
                plot(kdexx,kdedens,'k-')
                % numerical integration
                scatter(P.Xp(:,j),0.1*P.c/max(abs(P.c))-1)
                
%                 if(P.pdim==2)
%                     plot(xx,nummargin(j,:),'b-')
%                 end
                legend('rbf on particles','kde on mcmc samples','particle with weights','trapezoidal integration on equidistant grid')
                
                xlim([P.paramspec{j}{3},P.paramspec{j}{4}]);
                xlabel(['log(' P.paramspec{j}{1} ')'])
            else
                % 2D 
                
                % evaluation points
                xx = linspace(P.paramspec{k}{3},P.paramspec{k}{4},NV);
                yy = linspace(P.paramspec{j}{3},P.paramspec{j}{4},NV);
                
                [XX,YY] = meshgrid(xx,yy);
                
                X = [XX(:),YY(:)];

                SIS = pinv(sqrtm(SIGMA([k j],[k j])));
                if(P.kernel_aniso > 1)
                    rr = sqrt(sqdistance((bsxfun(@minus,X,P.Xmean([k j]))*SIS)',(bsxfun(@minus,P.Xp(:,[k j]),P.Xmean([k j]))*SIS)'));
                else
                    rr = sqrt(sqdistance((X)',(P.Xp(:,[k j]))'));
                end
                Z = 1/(sqrt(det(SIGMA([k j],[k j]))/P.eps^2*pi))*rbf(rr,P.eps)*P.c/abs(sum(P.c));
                
                surf(XX,YY,reshape(Z,size(XX)));
                xlim([P.paramspec{k}{3},P.paramspec{k}{4}]);
                ylim([P.paramspec{j}{3},P.paramspec{j}{4}]);
                view(0,90)
                shading interp
                xlabel(['log(' P.paramspec{k}{1} ')'])
                ylabel(['log(' P.paramspec{j}{1} ')'])
            end
        end
    end
    
end

