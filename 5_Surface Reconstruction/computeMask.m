function mask = computeMask(img_cell)
    mask = zeros(size(img_cell{1}));
    for i = 1:size(img_cell)
        mask = mask | img_cell{i};
    end
end
