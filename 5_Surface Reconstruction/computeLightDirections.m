function light_dirs_5x3 = computeLightDirections(center, radius, img_cell)
    light_dirs_5x3 = zeros(size(img_cell, 1), 3);
    for i = 1 : size(img_cell, 1)
        % find the intensity of the brightest pixel
        max_intensity = double(max(img_cell{i}(:)));
        
        %Find all brightest pixels, having same maximum values and find
        %centroid 
        [y,x] = find(img_cell{i} == max_intensity);
        norm_vec_x = mean(x) - center(2);
        norm_vec_y = mean(y) - center(1);
        norm_vec_z = sqrt(radius^2 - (norm_vec_x^2 + norm_vec_y^2));
        
        % Let the magnitude of light directions be the max intensity
        light_dirs_5x3(i, :) = [norm_vec_x, norm_vec_y, norm_vec_z] / radius * max_intensity;
    end
end