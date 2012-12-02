%% 0 Problem
%
% See nonasymptotic mixing of the MALA
% 
% $$ \pi (x) = Z^{-1} exp(-\beta U(x)) \quad | \quad Z=\int exp(-\beta U(x))$$
%
% $$ U = (\frac{x^2}{2})^2 $$
%
% $$ dY_\tau = -\nabla U(Y_\tau) d\tau + \sqrt{2\beta^{-1}}dW_\tau $$
%
% Feynman Kac
%
% $$ dY_\tau = \mu d\tau + \sigma dW_\tau $$
%
% $$ \mu = - \nabla U(Y_\tau) $$
%
% $$ \sigma = \sqrt{2\beta^{-1}} $$
%
% $$ g(\tau,x) = E(h(Y_T)|Y_0 = x) $$
%
% $$ g_\tau(\tau,x) = - \mu g_x - \frac{1}{2} \sigma^2 g_xx \quad | \quad  g(T,x) = h(x) $$
%
% Reverse time :
%
% $$ t = T - \tau \quad dt = -d\tau $$
%
% $$ g_t = \mu g_x + \frac{1}{2} \sigma^2 g_xx \quad | \quad g(0,x) = h(x) $$
%
% $$ g_t = - x * g_x + \beta^{-1} g_xx
clear all;
clf
opts=optimset('TolFun',1e-2,'TolX',1e-2);

%% 1 Parameters

%% 1.0 Problem

beta = @(t) 1;

t0 = 0;
tf = 1000;

%% 1.1 Time Stepping

% lagrangian velocity D()/Dt = d()/dt + u*\nabla()
du = 1;
% smallest inter particle spacing
dx = 0.01;
% CFL
dt = dx/du;

%% 1.4 Kernel 

eps = 3;

%% 1.3 Particle Distribution

%upper bound on the inter particle spacing
vs = 5;
D0 = 0.5;
Nstar = 8;
%rstar = sqrt(3);
rstar = 3;
dc = 2.5;
% probability tolerance for spawning of new particles
tol = 1e-10;

%% 1.4 Graphical Output

[VX,VY] = meshgrid(linspace(-vs,vs,30),linspace(-vs,vs,30));
Xv = [VX(:),VY(:)];
figure(1)

%% 2 Implementation

%% 2.1 Initialization

N = 100;
d = 2;

% initialise positions

Xp = randn(N,d)+1;
%Xp = [0 0];
D = distm_mex(Xp,Xp);



% initialise radii

Dp = exactDp(Xp,ngprior(Xp),rstar,D0);
rcp = rstar*Dp;

% initialise energy
WI = [];



%% 2.2 Initial particle distribution
figure(1)
clf
Iiter = 1;
try 
    load Xp_init
    Xp = Xp_init;
    vs = 3;
catch    
    while(true)
        subplot(3,3,1)
        hold off
        Iiter
        
        k=1;
        hold off
        plot(Xp(:,1),Xp(:,2),'o')
        xlim([-vs,vs])
        ylim([-vs,vs])
        drawnow
        hold on
        
        % fuse particles
        [Xp,rcp] = fuse_particles( Xp,Dp,rstar );
        
        Dp = exactDp(Xp,ngprior(Xp),rstar,D0);
        rcp = rstar*Dp;
        
        % spawn new particels
        [Xp] = spawn_particles( Xp,Dp,rcp,Nstar,rstar,D0,tol,prior(Xp) );
        
        Dp = exactDp(Xp,ngprior(Xp),rstar,D0);
        rcp = rstar*Dp;
        
        % gradient descent direction
        [ wp,WI ] = gradient_descent( Xp,Dp,rcp,rstar,D0,WI,Iiter,opts );
        
        % line search for gradient descent step size and move particels by one step
        [gamma] = fminsearch(@(g) InitOrgEnergy(Xp+g*wp,ngprior(Xp),rstar,D0),-1,opts);
        Xp = Xp + gamma*wp;
        
        plot(Xp(:,1),Xp(:,2),'mo')
        drawnow
        
        Dp = exactDp(Xp,ngprior(Xp),rstar,D0);
        rcp = rstar*Dp;
        
        Dpq = bsxfun(@min,Dp,Dp');
        Rpq = distm_mex(Xp,Xp);
        crit = Dpq./Rpq;
        Nlist = (Rpq<min(repmat(rcp,1,size(Xp,1)),repmat(rcp',size(Xp,1),1)))-logical(eye(size(Xp,1)));
        
        %graphical output
        NI(Iiter) = sum(sum(Nlist(prior(Xp)>tol,:),2)<Nstar-1);
        CI(Iiter) = max(max(crit(logical(Nlist))));
        plot_points( Xv,Xp,rcp,prior(Xp),VX,VY,WI,NI,CI,dc,Iiter,Nlist,Nstar,vs,1 )
        
        Iiter = Iiter+1;
        
        % if stopping criterion of gradient descent is reached and every particle has N* neighbors stop, else repeat.
        % for crit to work we need to substract a logical eye from Nlist, this leads to Nstar-1
        if(sum(sum(Nlist(prior(Xp)>tol,:),2)<Nstar-1)==0 && max(max(crit(logical(Nlist))))<=dc)
            break;
        end
    end
end

Xp_init=Xp;
save Xp_init
rcp_init=rcp;


f = prior(Xp);
Xp = Xp(f>tol,:);
f = f(f>tol);
Dp = Dp(f>tol);
rcp = rcp(f>tol);

%% 2.3 Start solving PDE 

Piter = 1;
% Time Stepping
t=t0;
n=3;

while (t<tf)
    figure(2)
    clf
    % advect particles
    disp('advecting')
%     Xp_adv=zeros(size(Xp));
%     for m=1:size(Xp,1)
%         [ik,xt]=ode45(@(t,x) gradllh(t,x),[t,t+dt],Xp(m,:)');
%         Xp_adv(m,:) = xt(end,:)';
%     end
    Xp_adv = Xp + dt*gradllh(0,Xp);


    [OP,D1,D2,M_int,M_eval,M_target] = Lop(Xp_adv,Xp,rcp,1,1);
    
    EV = eig(OP);
    % scale dt according to eigenvalues to assure stability
    dt = 1/((max(abs(EV))+min(abs(EV)))/2);
    % euler integration scheme
    E = M_eval/M_int;
    L = dt*OP + E;
    % apply operator
    F=L*f;
    % assure conservation
    c=M_target\F;
    I=sum(irbf(c,eps,sum(Xp,2)));
    c=c/I;
    F=M_target*c;
    
    plot_operator( Xp,Xp_adv,rcp,vs,f,F,E,D1,D2,EV,dt,c,2,0 )
    
    f=F;
 
    Xp=Xp_adv;
    % reorganize particles ?
    n=n-1;
    
    if (n==0)
        
        figure(3)
        clf
        n=15;
        % construct CD-PSE operators
        
        % compute Dpn
        Dp = calcDp(Xp,Xp,rstar,D0,rcp,f);
        rcp = rstar*Dp;
        if any(isnan(rcp))
            display('Something went wrong')
        end
        subplot(3,3,4)
        tri = delaunay(Xp(:,1),Xp(:,2));
        trisurf(tri,Xp(:,1),Xp(:,2),rcp)
        xlim([-vs,vs])
        ylim([-vs,vs])
        shading interp
        view(0,90)
        colormap(jet)
        colorbar
        title('rcp')

        % save points
        Xp_old = Xp;
        Dp_old = Dp;
        rcp_old = rcp;
        
        cDp = TriScatteredInterp(Xp,Dp);
        cDpNN = TriScatteredInterp(Xp,Dp,'nearest');
        cFp = TriScatteredInterp(Xp,f);
        
        % init plotting 
        Aiter = 1;
        WA=[];
        NA=[];
        CA=[];
        
        % create x_new
        while(true)            
            subplot(3,3,1)
            hold off           
            % remove bad particles
          
            % fuse particles where |xp_xq|<Dpq/
            % do this in a greedy-type fashion by removing particles with most points inside the cutoff radius first
            k=1;
            plot(Xp(:,1),Xp(:,2),'o')
            drawnow
            hold on
            
            % fuse particles
            [Xp,rcp] = fuse_particles( Xp, Dp, rstar );
            
            Fp=cFp(Xp);
            % spawn particles                      
            [Xp] = spawn_particles( Xp,Dp,rcp,Nstar,rstar,D0,tol,Fp ); 
            
            Dp = cDp(Xp);
            rcp = rstar*Dp;
            if any(isnan(rcp))
                Dp(isnan(rcp)) = cDpNN(Xp(isnan(rcp),:));
                rcp = rstar*Dp;
            end
            
            % compute total energy and gradient
            [ wp,WA ] = gradient_descent( Xp,Dp,rcp,rstar,D0,WA,Aiter,opts );
            
            % line search for gradient descent step size and move particels by one step
            [gamma] = fminsearch(@(g) OrgEnergy(Xp+g*wp,cDp,cDpNN,D0),-1,opts);
            Xp = Xp + gamma*wp;
            
            Dp = cDp(Xp);
            rcp = rstar*Dp;
            if any(isnan(rcp))
                Dp(isnan(rcp)) = cDpNN(Xp(isnan(rcp),:));
                rcp = rstar*Dp;
            end
            
            plot(Xp(:,1),Xp(:,2),'mo')
            drawnow
            
            % compute total energy and gradient
            Dpq = bsxfun(@min,Dp,Dp');
            Rpq = distm_mex(Xp,Xp);
            crit = Dpq./Rpq;
            Nlist = (Rpq<min(repmat(rcp,1,size(Xp,1)),repmat(rcp',size(Xp,1),1)))-logical(eye(size(Xp,1)));
            
            %graphical output
            NA(Aiter) = sum(sum(Nlist(prior(Xp)>tol,:),2)<Nstar-1);
            CA(Aiter) = max(max(crit(logical(Nlist))));
            plot_points( Xv,Xp,rcp,IntOp(Xp,Xp_old,rcp_old)*f,VX,VY,WA,NA,CA,dc,Aiter,Nlist,Nstar,vs,3 )
            
            Aiter = Aiter+1;
            
            % if stopping criterion of gradient descent is reached and every particle has N* neighbors stop, else repeat.
            % for crit to work we need to substract a logical eye from Nlist, this leads to Nstar-1         
            if(sum(sum(Nlist(cFp(Xp)>tol,:),2)<Nstar-1)==0 && max(max(crit(logical(Nlist))))<=dc)              
                break;
            end        
        end       
        f=IntOp(Xp,Xp_old,rcp_old)*f;     
        Xp = Xp(f>tol,:);
        f = f(f>tol);
        Dp = Dp(f>tol);
        rcp = rcp(f>tol);
    end
    
    Piter = Piter + 1;
    % Advance time
    t = t + dt;
end



