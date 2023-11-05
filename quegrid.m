function p = quegrid(k, ij, N_px, N)
    p = zeros([1, 4]);
    p(1:2) = ij;
    p(3) = k;
    N = reshape(N(ij(1), ij(2), :), [1, 3]);
    p(4) = norm(N_px(k, :) - N) ^ 2;
    % p(4) = p(4) / N(3);
end
