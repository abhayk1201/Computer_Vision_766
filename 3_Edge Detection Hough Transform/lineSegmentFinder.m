function cropped_line_img = lineSegmentFinder(orig_img, hough_img, hough_threshold)
    [theta_num_bins, rho_num_bins] = size(hough_img);
    edge_img = im2double(edge(orig_img, 'canny', 0.12));       
    %dilated edge image to check if a point lies on a edge line   
    edge_dil_img = bwmorph(edge_img, 'dilate',5);
    edge_conv_img = bwmorph(edge_dil_img, 'erode', 4);
    
    [height, width] = size(orig_img);
    rho_maxm = sqrt(height^2 + width^2);
    fh1 = figure; imshow(orig_img); hold on;
    
    for theta_idx = 1 : theta_num_bins
        for rho_idx = 1 : rho_num_bins
            if hough_img(theta_idx, rho_idx) > hough_threshold
                theta_val = theta_idx * 180 / theta_num_bins;
                rho_val = rho_maxm * (rho_idx / (rho_num_bins / 2) - 1);                
                x = 1;
                while x <= height
                    % y * cos(theta) = x * sin(theta) + rho
                    y = x * tand(theta_val) + rho_val * secd(theta_val);
                    if (ceil(y) > 0 && ceil(y) < width ...
                        && edge_conv_img(round(x), ceil(y)) > 0)
                        x_1 = x;  y_1 = y;  %line start points
                        x = x + 0.01;
                        y = (x * tand(theta_val) + rho_val * secd(theta_val));
                        % keep the line if edge points lies on the edge line
                        while (x <= height && ceil(y) > 0 && ceil(y) < width ...
                                && edge_conv_img(round(x), ceil(y)) > 0)
                            x = x + 0.01;
                            y = x * tand(theta_val) + rho_val * secd(theta_val);
                        end
                        x_2 = x;  y_2 = y;  %line end points 
                        % small edge lines
                        if ((y_1-y_2)^2 + (x_1-x_2)^2 <25^2) 
                            plot([y_1, y_2], [x_1, x_2], 'Color', [0,1,1], 'LineWidth', 1);
                        else  % larger edge lines
                            plot([y_1, y_2], [x_1, x_2], 'Color', [0,1,1], 'LineWidth', 4);
                        end
                    end
                    x = x + 0.01;
                end
            end
        end
    end
    cropped_line_img = saveAnnotatedImg(fh1);
end
