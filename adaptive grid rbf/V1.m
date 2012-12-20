function [ V ] = V1( r )
    assert( isa(r,'double'))
    V = zeros(size(r));
    r = abs(r);
    V(0.5>r) = 0.0847*(r(0.5>r>=0.4));
    V(r>=0.5) = 0.8*2.5.^(1-5.*r(r>=0.5))-2.5.^(-4.*r(r>=0.5));
end

