function [P, R_que] = flood(ij, k, R, P, R_que, mapsize, N_px, N)
    ij_que = [ij + [1, 0]; ij + [-1, 0]; ij + [0, 1]; ij + [0, -1]];

    [ij_que, i_que] = findValidQues(ij_que, R, R_que, k, mapsize);

    if ~isempty(i_que)

        for i = 1:length(i_que)
            r = find(R_que(i_que(i), :) == 0, 1, 'first');
            R_que(i_que(i), r) = k;
            p = quegrid(k, ij_que(i, :), N_px, N);
            P = cat(1, P, p);

        end

    end

end

function i = s2i(ij, mapsize)
    i = ij(:, 1) + (ij(:, 2) - 1) * mapsize(1);
end

function [ij_que, i_que] = findValidQues(ij_que, R, R_que, k, mapsize)
    valid_indices = [ij_que(1, 1) <= mapsize(1); ...
                         ij_que(2, 1) >= 1; ...
                         ij_que(3, 2) <= mapsize(2); ...
                         ij_que(4, 2) >= 1];

    ij_que = ij_que(valid_indices, :);
    i_que = s2i(ij_que, mapsize);

    zero_R_indices = R(i_que) == 0;
    k_not_present = ~any(R_que(i_que, :) == k, 2);
    valid_indices = zero_R_indices & k_not_present;

    ij_que = ij_que(valid_indices, :);
    i_que = i_que(valid_indices);
end
