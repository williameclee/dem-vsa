R = uint16(zeros(size(Z))); % region map
R_que = uint16(zeros([size(Z(:)), 4])); % which region has the point been queed to
R(X_px(:, 1)) = 1:K; % assign the seeds to the region map
E = zeros(size(Z)); % local L2,1 error map
P = []; % que

% initial queing of the seeds
for k = 1:K
    ij = X_px(k, 2:3);
    R(ij(1), ij(2)) = k;
    [P, R_que] = flooding(ij, k, R, P, R_que, mapsize, N_px, N);
end

for count = 1:length(Z(:))
    [~, que_id] = min(P(:, 4));
    ij = P(que_id, 1:2);
    R(ij(1), ij(2)) = P(que_id, 3);
    E(ij(1), ij(2)) = P(que_id, 4);

    [P, R_que] = flooding(ij, P(que_id, 3), R, P, R_que, mapsize, N_px, N);
    % to do list: add a buffer to sort grids with high error
    repeated = P(:, 1) == P(que_id, 1) & P(:, 2) == P(que_id, 2);
    P(repeated, :) = [];

    if isempty(P)
        break
    end

end
