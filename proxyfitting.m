E_R = zeros([K,1]);

for k = 1:K
    [N_px(k, :), X_px(k, :), E_R(k)] = seeding((R == k), Nx, Ny, Nz, I, J, mapsize);
end
