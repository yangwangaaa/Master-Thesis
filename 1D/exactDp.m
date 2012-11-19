function Dp = exactDp(Xp,DF,rstar,Dzero)
    assert( isa(Xp,'double'))
    assert( isa(DF,'double'))
    assert( isa(rstar,'double'))
    assert( isa(Dzero,'double'))

    MF=monitor_function(DF,Dzero);
    
    for j=1:size(Xp,1)
        Dp_old = -inf;
        Dp(j) = MF(j);
        k=0;
        while((((abs(Dp_old-Dp(j)))/Dp(j))>1e-2) && k < 15)
            Dp_old = Dp(j);
            ind = (distm(Xp(j,:),Xp)<=rstar*Dp(j));
            if(sum(ind)>0)
                Dp(j) = min(MF(ind));
                k=k+1;
            else
                Dp(j) = MF(j);
                break;
            end
        end
    end
    if(size(Dp,2)>size(Dp,1))
        Dp=Dp';
    end
end