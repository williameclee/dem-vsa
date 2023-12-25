function [seeds, k] = initialseeding(mapsize, k)
    % Distribute (no less than) k seeds uniformly over the map

    k_1d = ceil(sqrt(k)); % number of seeds per dimension
    k = k_1d ^ 2; % updated number of seeds

    grid_spacing_x = mapsize(2) / k_1d;
    grid_spacing_y = mapsize(1) / k_1d;

    [I, J] = meshgrid(1:k_1d, 1:k_1d);
    I = round((I(:) - 0.5) * grid_spacing_x);
    J = round((J(:) - 0.5) * grid_spacing_y);

    I(I <= 1) = 1;
    I(I >= mapsize(2)) = mapsize(2);
    J(J <= 1) = 1;
    J(J >= mapsize(1)) = mapsize(1);

    seeds = zeros([k, 3]);
    seeds(:, 2) = J;
    seeds(:, 3) = I;
    seeds(:, 1) = sub2ind(mapsize, seeds(:, 2), seeds(:, 3));
end
