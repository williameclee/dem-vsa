function [normal, proxy, error] = seeding(region_mask, Nx, Ny, Nz, I, J, mapsize)
    % Find the new normal
    R_nx = Nx(region_mask);
    R_ny = Ny(region_mask);
    R_nz = Nz(region_mask);
    R_n = [mean(R_nx), mean(R_ny), mean(R_nz)];
    R_n = R_n / norm(R_n); % normalise
    normal = R_n;
    % Find the resulting error
    R_e = (R_nx - R_n(1)) .^ 2 + (R_ny - R_n(2)) .^ 2 + (R_nz - R_n(3)) .^ 2;
    error = sum(R_e ./ R_nz);
    % Find the new proxy index
    R_i = I(region_mask);
    R_j = J(region_mask);
    [~, R_ei] = min(R_e);
    proxy = [sub2ind(mapsize, R_j(R_ei), R_i(R_ei)), ...
                 R_j(R_ei), R_i(R_ei)];
end
