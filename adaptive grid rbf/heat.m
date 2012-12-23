clear all;
clf
P.opts=optimset('TolFun',1e-4,'TolX',1e-4);

%% 1 Parameters

%% 1.1 Data

% true parameters
P.k1=0.6;
P.k2=0.4;
P.y0=[0;1];
P.tN=60;
P.tdata=linspace(0,10,60);
explsol = @(t) P.k2/(P.k1+P.k2)*sum(P.y0)*(1-exp(-(P.k1+P.k2)*t));
P.ydata = explsol(P.tdata)'; 
P.sigma = 0.1;
P.species=1;

%% 1.2 Interpolation area

P.method_thresh = 1;
% 1: hard cutoff relative to maximum

% hard cutoff value
P.thresh = 1e-5;
P.rem_thresh = 1e-10;

%% 1.3 Initial Particle Guess

% method for spawning particles
P.init_method = 3;
% 1: equidistant euclidean
% 2: equidistant radial
% 3: single point at modes

% initial grid spacing
P.init_d0 = 0.1;
P.init_D0 = 0.5;

%% 1.4 Adaptive Grid

% method for adapting the grid
P.adap_method = 1;
% 1: local monitor function with function value
% 2: local monitor function with gradient
% 3: global neighborhood size
% 5: residual subsampling

% spawning method
P.adap_spawn_method = 1;
% 1: randomly in too small neighborhood
% 2: based on mean at edges

% fusion method
P.adap_fusion_method = 1;
% 1: where particles are too close to each other
% 2: no fusion

% potential function
P.adap_pot = 1;
% 1: V1, h-stable should be used for moving grids on unbounded domains and if the argument of the monitoring function 
% can become larger that (r*-1)
% 2: V2, should be used on bounded domains if the argument of the monitoring function stays smaller that (r*-1)
% 3: V1 with positive linear continuation instead of negative

% lower mesh bound
P.adap_d0 = 0.25;

% upper mesh bound
P.adap_D0 = 0.5;

% target Neighborhood size
P.adap_Nstar = 12;
% relative optimal distance tolerance
P.adap_dc = 1.7;

% relative neighborhood size
P.adap_rstar = 2;

% relative gradient influence radius
P.adap_gradr = 3;

% number of gradient steps
P.adap_ngradstep = 1;

%% 1.5 Kernel

% kernel
P.kernel = 1;
% 1: gaussian

% anisotropic transformation
P.kernel_aniso = 3;
% 1: isotropic
% 2: global anisotropic based on hessian
% 3: global anisotropic based on covariance
% 3: local anisotropic

% steps until update of covariance matrix
P.cov_iter = 3;

% shape parameter
P.kernel_shape = 1;
% 1: global;
P.riley_mu = 1e-11;
% 2: local;
% 3: local anisotropic;

% minimum value for shape parameter
P.kernel_eps_min = 1e-2;
% maximum value for shape parameter
P.kernel_eps_max = 1e2;

%% 1.6 Visualisation
P.vsx = 3;
P.vsy = 3;
P.vsT = 5;
P.vsN = 30;

[P.VX,P.VY] = meshgrid(linspace(-P.vsx,P.vsx,P.vsN),linspace(-P.vsy,P.vsy,P.vsN));
P.Xv = [P.VX(:),P.VY(:)];

%% 1.7 CVODE settings

% integration tolerances
P.ode_reltol = 1e-6;
P.ode_abstol = 1e-8;

structdxdt

P.mStructdxdt = mStructdxdt;

%% 2 Implementation

%% 2.1 Initialization

% parameter dimension
P.pdim = 2;
% species dimension
P.xdim = 2;



% initialise positions

P.D0 = P.init_D0;
P.d0 = P.init_d0;


P.Xp = log([P.k1,P.k2]);
if(P.kernel_aniso == 3)
    P.Tp = zeros(1,P.pdim);
    P.Xmean = log([P.k1,P.k2]);
    P.M = eye(P.pdim);
end

P.N = size(P.Xp,1);
P.Lp = ones(size(P.Xp,1),1);
P.fmax = 1;

if(P.kernel_aniso == 2)
    P = lapllh(P);
    P.C = squeeze(P.D2F(1,:,:))/norm(squeeze(P.D2F(1,:,:)),2);
elseif(P.adap_method == 2)
    P = gradllh(P);
else
    P = llh(P);
end

if(P.adap_method == 1 || P.adap_method == 2 || P.adap_method == 3)
    P = exactDp(P);
end

if(P.init_method == 1)
    P.euclid_occup(1,:) = zeros(1,P.dim,2);
end

P.fmax = P.F(1);




% initialise energy
WI = [];

P.Lh = [];

%% 2.2 Initial particle distribution

P.Iiter = 1;

P.Nprev = 0;

try
    load Xp_init
catch
    switch(P.init_method)
        case 1
            % still need to think of something smart
        case 2
            % still need to think of something smart
        case 3
            % nothing to do, we already have the initial point
    end
    
end

%% 2.3 Particle Refinement

P.Riter = 1;

try
    load Xp_init
catch
    while(true)
        %                 figure(2)
        % remove points below threshold
        
        ind = P.F > P.fmax*P.rem_thresh;
        P.kthresh(P.Riter)=P.N-sum(ind);
        P.F = P.F(ind);
        P.Xp = P.Xp(ind,:);
        if(P.kernel_aniso == 3)
            P.Tp = P.Tp(ind,:);
        end
        P.Dp = P.Dp(ind);
        P.Lp = P.Lp(ind);
        P.rcp = P.rcp(ind);
        P.N = size(P.Xp,1);
        
        P = fuse_particles( P );
        
        P = exactDp( P );
        %                 clf
        P = spawn_particles( P );
        
        P = exactDp( P );
        
        
        for s=1:P.adap_ngradstep
            P = gradient_descent( P );
            
            if(P.kernel_aniso == 3)
                P.cDp = TriScatteredInterp(P.Tp,P.Dp);
                P.cDpNN = TriScatteredInterp(P.Tp,P.Dp,'nearest');
            else
                P.cDp = TriScatteredInterp(P.Xp,P.Dp);
                P.cDpNN = TriScatteredInterp(P.Xp,P.Dp,'nearest');
            end
            
            
            [gamma] = fminsearch(@(g) OrgEnergy(P,g),0,P.opts);
            
            if(P.kernel_aniso == 3)
                P.Tp = P.Tp + gamma*P.wp;
            else
                P.Xp = P.Xp + gamma*P.wp;
            end
            
            P = exactDp(P);
            
            P.Dpq = bsxfun(@min,P.Dp,P.Dp');
            
            P.W2(P.Riter) = sum(sum(P.Dpq.^2*V1_mex(P.R./P.Dpq)));
        end
        
        if(P.kernel_aniso == 3)
            P = TptoXp(P);
        end
        P = llh(P);
        
        
        P = exactDp(P);
        
        if(P.kernel_aniso == 3)
            P.R = distm_mex(P.Tp,P.Tp);
        else
            P.R = distm_mex(P.Xp,P.Xp);
        end
        P.Dpq = bsxfun(@min,P.Dp,P.Dp');
        
        P.crit = P.Dpq./P.R;
        P.Nlist = (P.R<min(repmat(P.rcp,1,P.N),repmat(P.rcp',P.N,1)))-logical(eye(P.N));
        
        
        P.NI(P.Riter) = sum(sum(P.Nlist(P.F>P.fmax*P.thresh,:),2)<P.adap_Nstar-1);
        P.CI(P.Riter) = max(max(P.crit(logical(P.Nlist))));
        P.PI(P.Riter) = sum(P.F>P.fmax*P.thresh);
        P.XI(P.Riter) = P.N;
        P.Lp = P.Lp+ones(size(P.Lp));
        P.Lh = [P.Lh,zeros(size(P.Lh,1),max(size(hist(P.Lp,1:max(P.Lp)),2)-size(P.Lh,2),0));hist(P.Lp,1:max(P.Lp))/P.N,zeros(1,max(size(P.Lh,2)-size(hist(P.Lp,1:max(P.Lp)),2),0))];
        
        if(P.kernel_aniso == 3 && mod(P.Riter,P.cov_iter)==0 && P.PI(P.Riter)>2 && P.Riter<50)
            P.cov_iter=P.cov_iter+2;
            P = TptoXp(P);
            P = calc_transform(P);
            P = XptoTp(P);
        end
        
        
        plot_points( P,1 )
        
        P.Riter = P.Riter+1;
        
        if(sum(sum(P.Nlist(P.F>P.fmax*P.thresh,:),2)<P.adap_Nstar-1)==0 && max(max(P.crit(logical(P.Nlist))))<=P.adap_dc)
            break;
        end
    end
end

%% 2.4 Interpolation

if(P.kernel_aniso == 3)
    P.R = distm_mex(P.Tp,P.Tp);
else
    P.R = distm_mex(P.Xp,P.Xp);
end
P = llh(P);

switch(P.kernel_shape)
    case 1% 1: global
        P.eps = fminsearch(@(ep) CostEpsRiley(ep,P),P.kernel_eps_min,P.kernel_eps_max);
        P.RBF = rbf(P.R,P.eps);
        P.c = Riley_mex(P.RBF,P.F,P.riley_mu);
    case 2% 2: local
        
    case 3% 3: local anisotropic
        
end



