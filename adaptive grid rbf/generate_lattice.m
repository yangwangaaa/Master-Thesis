function [ P ] = generate_lattice( P )
    %GENERATE_LATTICE Summary of this function goes here
    %   Detailed explanation goes here
    
    % total number of particles in the previous iteration
    lspawn = 0;
    
    % total number of particles
    tspawn = 1;
    
    % integer coordinats
    L = zeros(1,P.pdim);
    
    % Function value
    LF = P.fmax;
    
    % neighbor flags;
    nbor = zeros(1,2*P.pdim);
    % 1:pdim neighbor in negative direction already exists
    % pdim+1:2pdim neighbor in positve direction already exists
    
    XX = P.Xp(1,:);
    
    % stop until we add no further particles
    while(tspawn - lspawn > 0)
        for j = lspawn+1 : tspawn 
            if(LF(j,1)>P.fmax*P.thresh)
                for k = 1 : P.pdim
                    if(nbor(j,P.pdim+k) == 0)
                        add = zeros(1,P.pdim);
                        nb = zeros(1,2*P.pdim);
                        add(k) = 1;
                        nb(k) = 1;
                        L(end+1,:) = L(j,:)+add;
                        nbor(end+1,:) = nb;
                    end
                    if(nbor(j,k) == 0)
                        add = zeros(1,P.pdim);
                        nb = zeros(1,2*P.pdim);
                        add(k) = -1;
                        nb(P.pdim+k) = 1;
                        L(end+1,:) = L(j,:)+add;            
                        nbor(end+1,:) = nb;
                    end
                end
            end
        end
        lspawn = tspawn;
        [~,ind] = unique(L,'rows','first');
        ii = sort(ind);
        L=L(ii,:);
        nbor=nbor(ii,:);
        tspawn = size(L,1);
        for j = lspawn + 1 : tspawn
            LF(j,1) = eval_llh(XX+L(j,:)*P.Gram,P);
        end

        figure(5)
        
        XL = L*P.Gram;
        scatter3(XL(:,1),XL(:,2),XL(:,3),max(log(LF)/log(10),1e-16),max(log(LF)/log(10),1e-16));
    end

    P.Xp = bsxfun(@plus,P.Xp(1,:),L*P.Gram);
    P.F = LF;
    
end

