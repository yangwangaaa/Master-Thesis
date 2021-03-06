function [ P ] = init( P )
    %INIT Initialises the algorithm with an initial particle distribution
    % and an approximation to the anisotropy transformation
    
    P.feval_latt = 0;
    P.feval_adap = 0;
    
    disp(['------- Initialising Problem -------'])
    
    % compute target neighborhood size
    %P = find_Nsize( P );  
    switch(P.pdim)
        case 1
            P.adap_Nstar = 1;
        case 2
            P.adap_Nstar = 6;
        case 3
            P.adap_Nstar = 12;
        case 4
            P.adap_Nstar = 24;
    end
    
    %disp(['Neighborhood Size: ' num2str(P.adap_Nstar)])
    
    % compute soft spawning stop
    P.thresh = exp(-chi2inv(P.alpha,P.pdim)/2);
    
    disp(['Relative spawning factor: ' num2str(P.thresh)]);
                
    P.D0 = P.init_D0;
    P.d0 = P.init_d0;
    
    % initialise initial point
    P.Xp = P.logscale(P.estim_param).*log(P.k(P.estim_param))+(1-P.logscale(P.estim_param)).*P.k(P.estim_param);
    if(P.model == 4)
        P.Xp = P.Xp(1,1:P.pdim);
    end
    
    P.N = size(P.Xp,1);
    
    if(P.init_trans == 3)
        % compute hessian for initial point
        P = lapllh(P);
    elseif(P.adap_method == 2 || P.init_trans == 2 )
        % compute gradient for initial point
        P = gradllh(P);
    else
        % compute function value for initial point
        P = llh(P);
    end
    
    % initialise maximum function value
    P.fmax = max(P.F);

    if(P.kernel_aniso > 1)
        % generate first transformed point
        P.Tp = zeros(1,P.pdim);
        % set mean as initial pint
        if(P.model == 5)
            SIGMA1=[0.1 0.25;0.25 1];
            SIGMA2=[0.01 -0.01;-0.01 0.5];
            MU1 = [1 1];
            MU2 = [0.5 -1.5];
            w1 = 4/5;
            w2 = 1/5;
            P.Xmean = w1 * MU1 + w2 * MU2;
        else
            P.Xmean = P.Xp;
        end
        % initialise transformation
        switch(P.init_trans)
            case 1
                % initialise transform with initial point
                P.M = eye(P.pdim);
            case 2
                % initialise transform with fisher matrix of initial point
                if(P.model < 4 )
                try
                    P.M = sqrtm(pinv(squeeze(P.S(1,:,:))));
                catch
                    P.M = sqrtm(pinv(squeeze(P.S(1,:,:)) + 1e-10*diag(P.pdim)));
                end
                elseif(P.model == 4)
                    % unknown!
                    P.M = eye(P.pdim);
                elseif(P.model == 5)
                    % we can compute the exact covariance

                    C = w1*SIGMA1 + w2*SIGMA2 + w1*MU1'*MU1 + w2*MU2'*MU2 - (w1^2*MU1'*MU1 + w1*w2*(MU1'*MU2 + MU2'*MU1) + w2^2*MU2'*MU2);
                    P.M =  sqrtm(C);
                end
                
            case 3
                % initialise with hessian
                try
                    P.M = sqrtm(-squeeze(P.D2F(1,:,:)));
                catch
                    % this might fail if we are not positive definite so add regularization term
                    P.M = sqrtm(-squeeze(P.D2F(1,:,:))/P.fmax + 1e-10*diag(P.pdim));
                end
        end
        
        P.Minit = P.M;
    
    else
        P.M = eye(P.pdim);
        P.Minit = P.M;
        
    end
    
    
    % initialise particle ages
    

    %% 2.3 Initial particle distribution
    
    % number of iterations for initialisation
    P.Iiter = 1;
    P.Init_rad = P.D0;
    
    
        switch(P.init_method)
        case 1
            disp(['Initialising with single point at mode'])
            % nothing to do, we already have the modes!
        case 2
            %Generator Matrix
            switch(P.init_lattice)
                case 1
                    disp(['Initialising with Z lattice'])
                    M = eye(P.pdim);
                    % reduce basis
                    M = LLL_reduction(M);
                    %normalise
                    M = M/mean(sqrt(sum(M.^2,2)));
                case 2
                    disp(['Initialising with A lattice'])
                    M = ones(P.pdim,P.pdim)+diag(ones(P.pdim,1))*(sqrt(P.pdim+1)+1);
                    % reduce basis
                    M = LLL_reduction(M);
                    %normalise
                    M = M/mean(sqrt(sum(M.^2,2)));
                case 3
                    disp(['Initialising with D lattice'])
                    M = [2 zeros(1,P.pdim-1);ones(P.pdim-1,1),diag(ones(P.pdim-1,1))];
                    % reduce basis
                    M = LLL_reduction(M);
                    %normalise
                    M = M/mean(sqrt(sum(M.^2,2)));
                case 4
                    disp(['Initialising with A* lattice'])
                    M = ones(P.pdim,P.pdim)+diag(ones(P.pdim,1))*(sqrt(P.pdim+1)-1+P.pdim);
                    % reduce basis
                    M = LLL_reduction(M);
                    %normalise
                    M = M/mean(sqrt(sum(M.^2,2)));
                case 5
                    disp(['Initialising with D* lattice'])
                    % reduce basis
                    M = LLL_reduction(M);
                    %normalise
                    M = M/mean(sqrt(sum(M.^2,2)));
            end
            % Gram Matrix
            P.Generator = P.init_latt_d*(P.M*M);
            % generate the lattice
            P = generate_lattice(P);
%             if(P.kernel_aniso > 1);
%                 disp(['Regenerating Lattice with updated Covariance Matrix'])
%                 P = XptoTp(P);
%                 P.N = size(P.Xp,1);
%                 if(P.kernel_aniso > 1) 
%                     P.R = sqrt(sqdistance(P.Tp'));
%                 else
%                     P.R = sqrt(sqdistance(P.Xp'));
%                 end
%                 P = exactDp(P);
%                 P = calc_transform( P );
%                 P.Generator = P.init_latt_d*(P.M*M);
%                 P = generate_lattice(P);
%             end
            P = XptoTp(P);
    end
    
    % compute number of points
    P.N = size(P.Xp,1);
    
    
    
    if(P.adap_method == 1 || P.adap_method == 2 || P.adap_method == 3)
        % initialise neighborhood sizes
        if(P.kernel_aniso > 1)
            
            P.R = sqrt(sqdistance(P.Tp'));
        else
            P.R = sqrt(sqdistance(P.Xp'));
        end
        P = exactDp(P);
    end
    
    P.Lp = ones(size(P.Xp,1),1);
    
    % approximate with markov chain, this will be used for error calculation later on
    
    disp(['Running MCMC for error calcuations'])
    
    P = mcmc(P);
    
end

