function seeds = initialseeding(mapsize, k)
    % Preallocation
    seeds = zeros([k, 3]);

    k_1d = ceil(sqrt(k));
    scale_factor_x = mapsize(2) / k_1d;
    scale_factor_y = mapsize(1) / k_1d;

    k_max = k_1d ^ 2;
    k_excess = k_max - k;

    [I, J] = meshgrid(1:k_1d, 1:k_1d);
    I = I(:) - 0.5;
    J = J(:) - 0.5;

    if k_excess > 0
        k_skip = floor(k_max / k_excess);
        idx = true(k_max, 1);
        idx(k_skip:k_skip:end) = false;
        I = I(idx);
        J = J(idx);
    end

    seeds(:, 2) = round(J * scale_factor_y);
    seeds(:, 2) = min(max(seeds(:, 2), 1), mapsize(1));
    seeds(:, 3) = round(I * scale_factor_x);
    seeds(:, 3) = min(max(seeds(:, 3), 1), mapsize(2));
    seeds(:, 1) = sub2ind(mapsize, seeds(:, 2), seeds(:, 3));
end
