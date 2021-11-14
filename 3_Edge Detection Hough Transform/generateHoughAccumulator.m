function hough_img = generateHoughAccumulator(img, theta_num_bins, rho_num_bins)
    %rho_vals_count = 2 * rho_num_bins + 1;  % -rho to rho
    hough_img = zeros(theta_num_bins, rho_num_bins);
    [height, width] = size(img);
    max_rho = sqrt(height^2 + width^2);
    max_theta = 180; %match lies only in range of (0, pi)
    
    for row = 1 : height
        for col = 1 : width
            %presence of edge pixel
            if img(row, col) ~= 0  
                for theta_idx = 1 : theta_num_bins
                    % rho = y(col) * cos(thetha) - x(row) * sin(thetha)
                    rho = col * cosd(theta_idx/theta_num_bins * max_theta) - row * sind(theta_idx/theta_num_bins * max_theta);
                    rho_bin_idx = round(rho/max_rho * rho_num_bins/2 + rho_num_bins/2);
                    if rho_bin_idx > 0 && rho_bin_idx <= rho_num_bins
                        hough_img(theta_idx, rho_bin_idx) = hough_img(theta_idx, rho_bin_idx) + 1;
                    end
                end
            end
        end
    end
    
    % scale accumulator imaage between 0 and 255 
    hough_img = 255 * mat2gray(hough_img, [min(hough_img(:)), max(hough_img(:))]);
end
