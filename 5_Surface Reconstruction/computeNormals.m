function [normals, albedo_img] = computeNormals(light_dirs, img_cell, mask)

    [height, width] = size(mask);
    normals = zeros(height, width, 3);
    all_img =  zeros(height, width, 3);
    albedo_img = zeros(height, width);
    S = light_dirs;
    for i = 1:size(img_cell,1)
        all_img(:,:,i) = img_cell{i}(:,:);
    end
    %surface normals for the background pixels points at the camera
    normals(:, :, 3) = 1;
    
    for row_idx = 1 : height
        for col_idx = 1 : width
            %only foregroud & not background pixel
            if mask(row_idx, col_idx)  == 1 
                I = double(squeeze(all_img(row_idx,col_idx,:)));                          
                N = (S' * S) \ S' * I;
                normals(row_idx, col_idx, :) = N / norm(N);
                albedo_img(row_idx, col_idx) = norm(N);
            end
        end
    end
    
    % Scaling albedo img
    albedo_img = im2double(albedo_img);
    max_alb = max(albedo_img(:));
    albedo_img = albedo_img / max_alb;
end
 
