function result = computeFlow(img1, img2, win_radius, template_radius, grid_MN)
    [ht, wid] = size(img1);
    int_ht  = round(ht / grid_MN(1));
    int_wid = round(wid / grid_MN(2));
    opt_flow_start = [];
    opt_flow_vec = [];
    for x = int_wid  : int_wid : wid-int_wid
        for y = int_ht : int_ht : ht-int_ht
            temp_x_min = max(1, x - template_radius);
            temp_y_min = max(1, y - template_radius);
            temp_x_max = min(wid, x + template_radius);
            temp_y_max = min(ht, y + template_radius);
            template = img1(temp_y_min:temp_y_max, temp_x_min:temp_x_max);
            
            window_x_min = max(1, x - win_radius);
            window_y_min = max(1, y - win_radius);
            window_x_max = min(wid, x + win_radius);
            window_y_max = min(ht, y + win_radius);            
            window = img2(window_y_min:window_y_max, window_x_min:window_x_max);            
            
            cross_corr = normxcorr2(template, window);
            % Adjust extra padding added by normxcorr2
            cross_corr = cross_corr(size(template, 1) : size(cross_corr, 1) - size(template, 1), size(template, 2) : size(cross_corr, 2) - size(template, 2));
            [y_match, x_match] = find(cross_corr == max(cross_corr(:)));
            
            %store all the starting points and vectors of optical flow needles
            opt_flow_start = [opt_flow_start; y, x];
            opt_flow_vec = [opt_flow_vec; x_match - (temp_x_min - window_x_min + 1), y_match - (temp_y_min - window_y_min + 1)];
        end
    end
    
    % draw optical flow needles.
    fig1 = figure;
    imshow(img1); hold on;
    quiver(opt_flow_start(:, 2), opt_flow_start(:, 1), opt_flow_vec(:, 1), opt_flow_vec(:, 2), 0, 'filed', 'g', 'LineWidth', 1);
    result = saveAnnotatedImg(fig1);
    close(fig1);
end
