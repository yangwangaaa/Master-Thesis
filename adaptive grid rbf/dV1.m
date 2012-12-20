function [ V ] = dV1( r )
    V = zeros(size(r));
    r = abs(r);
    %V(0.5>r) = 0.0847;
    %V(r>=0.5) = (-5)*log(2.5)*0.8*2.5.^(1-5.*r(r>=0.5))-(-4)*log(2.5)*2.5.^(-4.*r(r>=0.5));
    V = (-5)*log(2.5)*0.8*2.5.^(1-5.*r)-(-4)*log(2.5)*2.5.^(-4.*r);
end

