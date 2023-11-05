% clear
% clc

% %% Load data
vsa_demo_loaddata

%% Geometry partitioning
% Initial seeding
K = 300;
X_px = initialseeding(size(Z), K);
N_px = zeros([K, 3]);

for k = 1:K
    N_px(k, :) = N(X_px(k, 2), X_px(k, 3), :);
end

R = uint16(zeros(size(Z)));
R_que = uint16(zeros([size(Z(:)), 4]));
R(X_px(:, 1)) = 1:K;
P = [0, 0, 0, 0];

for k = 1:K
    ij = X_px(k, 2:3);
    R(ij(1), ij(2)) = k;
    [P, R_que] = flood(ij, k, R, P, R_que, mapsize, N_px, N);
end

P = P(2:end, :);

for count = 1:length(Z(:))
    [~, que_id] = min(P(:, 4));
    ij = P(que_id, 1:2);
    R(ij(1), ij(2)) = P(que_id, 3);

    [P, R_que] = flood(ij, P(que_id, 3), R, P, R_que, mapsize, N_px, N);
    % to do list: add a buffer to sort grids with high error
    repeated = P(:, 1) == P(que_id, 1) & P(:, 2) == P(que_id, 2);
    P(repeated, :) = [];

    if isempty(P)
        break
    end

end

for k = 1:K
    N_px(k, 1) = mean(Nx(R == k));
    N_px(k, 2) = mean(Ny(R == k));
    N_px(k, 3) = mean(Nz(R == k));
    N_px(k, :) = N_px(k, :) / norm(N_px(k, :));
end

%
figure(1)
clf
subplot(1, 2, 1)
imagesc(Z)
colormap("parula")
set(gca, "YDir", "normal")

subplot(1, 2, 2)
surf(Z, mod(R, 13), "LineStyle", "none")
% imagesc(mod(R,13))
colormap("parula")
set(gca, "YDir", "normal")
