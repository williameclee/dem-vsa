%% Finding connected regions

connectivity = false([K, K]);

is_boundary = false(size(R));
right_is_boundary = false(size(R));
top_is_boundary = false(size(R));

right_is_boundary(:, 1:end - 1) = (R(:, 2:end) ~= R(:, 1:end - 1));
top_is_boundary(1:end - 1, :) = (R(2:end, :) ~= R(1:end - 1, :));

boundary_i = I(right_is_boundary);
boundary_j = J(right_is_boundary);
boundary_R1 = R(sub2ind(size(R), boundary_j, boundary_i));
boundary_R2 = R(sub2ind(size(R), boundary_j, boundary_i + 1));
connectivity(sub2ind(size(connectivity), boundary_R1, boundary_R2)) = true;
connectivity(sub2ind(size(connectivity), boundary_R2, boundary_R1)) = true;

boundary_i = I(top_is_boundary);
boundary_j = J(top_is_boundary);
boundary_R1 = R(sub2ind(size(R), boundary_j, boundary_i));
boundary_R2 = R(sub2ind(size(R), boundary_j + 1, boundary_i));
connectivity(sub2ind(size(connectivity), boundary_R1, boundary_R2)) = true;
connectivity(sub2ind(size(connectivity), boundary_R2, boundary_R1)) = true;

%% Merging
deleted_regions = [];
for r1 = 1:K
    for r2 = 1:r1-1
        if ~connectivity(r1,r2) 
            continue
        end
        new_region_mask = (R == r1 | R == r2);
        [normal, proxy, error] = seeding(new_region_mask, Nx, Ny, Nz, I, J, mapsize);
        
        if error < 500
            R(new_region_mask) = r1;
            X_px(r1, :) = proxy;
            N_px(r1, :) = normal;
            deleted_regions = [deleted_regions, r2];
            connectivity(r1, :) = connectivity(r1, :) | connectivity(r2, :);
            connectivity(:, r1) = connectivity(:, r1) | connectivity(:, r2);
            connectivity(r2, :) = false;
            connectivity(:, r2) = false;
        end
    end
end
%% Update K
for k = 1:K
    R(R == k) = k - sum(deleted_regions < k);
end
K = K - length(deleted_regions);

subplot(1, 2, 1)
imagesc(mod(R, 13))
set(gca, 'YDir', 'normal')
subplot(1, 2, 2)
imagesc(connectivity)
axis equal
set(gca, 'YDir', 'normal')
