function [f,Df,F] = eval_gradllh(p,P)
    
    inbound = true;
    
    for k=1:P.pdim
        if(p(k)<P.paramspec{k}{3}||p(k)>P.paramspec{k}{4})
            inbound = false;
            break
        end
    end
    
    if((1-P.logscale(P.estim_param)).*p<0)
        f = 0;
        Df = zeros(1,P.pdim);
        F = zeros(P.pdim,P.pdim);
    elseif(not(inbound))
        f = 0;
        Df = zeros(1,P.pdim);
        F = zeros(P.pdim,P.pdim);
    else
        if(P.model == 4)
            [f,Df] = P.loglikelihood(p);
            f = exp(f+9.0498e5);%add normalization
            %f = exp(f+1.0715941e6);
            if(P.kernel_aniso > 1)
                Df = f*Df;
            else
                Df = f*Df;
            end
            F = eye(P.pdim);
        elseif(P.model == 5)
            f = exp(P.loglikelihood(p));
            SIGMA1=[0.1 0.25;0.25 1];
            SIGMA2=[0.01 -0.01;-0.01 0.5];
            MU1 = [1 1];
            MU2 = [0.5 -1.5];
            Df = -4/5*mvnpdf(p,MU1,SIGMA1)*(-(p - MU1)*pinv(SIGMA1)) + 1/5*mvnpdf(p,MU2,SIGMA2)*(-(p - MU2)*pinv(SIGMA2));
        else
            
            
            % get number of states
            xdim = P.xdim;
            % get number of parameters
            pdim = P.pdim;
            % reparametrise
            pt = P.logscale.*exp(p) + (1-P.logscale).*p;
            % solve ode with sensitivities
            [~,yy] = ode15s(@(t,x) P.dxdp(t,x,pt,[],P.mStructdxdt),P.tdata,[P.y0;zeros(xdim*pdim,1)]);
            
            % compute likelihood
            f = exp(sum(sum(log(normpdf(yy(:,P.species),P.ydata,P.sigma)))));
            
            MS = zeros(xdim,pdim);
            % compute gradient
            Df = zeros(1,P.pdim);
            F = zeros(P.pdim,P.pdim);
            try
                for tk=1:length(P.tdata)
                    DXDP = reshape(yy(tk,xdim+1:end),xdim,pdim);
                    jspec = 1;
                    for s=P.species
                        Df = f*2*(P.ydata(tk,jspec)-yy(tk,s))/P.sigma^2*DXDP(s,:).*(P.logscale.*exp(p) + (1-P.logscale));
                        Dlogf = 2*(P.ydata(tk,jspec)-yy(tk,s))/P.sigma^2*DXDP(s,:).*(P.logscale.*exp(p) + (1-P.logscale));
                        jspec=jspec+1;
                        F = F + 1/P.sigma^2*(DXDP(s,:)'*DXDP(s,:));
                    end
                    MS = MS + DXDP;
                end
            catch
                f=0;
            end
        end
    end
end