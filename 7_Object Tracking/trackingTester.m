function trackingTester(data_params, tracking_params)
    start_frame = imread(fullfile(data_params.data_dir, data_params.genFname(data_params.frame_ids(1))));
    
    %create output directory
    if ~exist(data_params.out_dir, 'dir')
       mkdir(data_params.out_dir)
    end
    
    target_rect = tracking_params.rect;
    num_bins = tracking_params.bin_n;
    search_window_size = tracking_params.search_half_window_size;
    
    %[xmin ymin width height];
    template = start_frame(target_rect(2):target_rect(2) + target_rect(4), target_rect(1):target_rect(1) + target_rect(3), :);

    % divide the color range of an image into several bins
    % histc to compute the color histogram of the image
    [template_ind, template_map] = rgb2ind(template, num_bins);
    template_hist = histc(template_ind(:), 1:num_bins);
    
    % iterate over all frame_ids
    for i = data_params.frame_ids
        next_frames = imread(fullfile(data_params.data_dir, data_params.genFname(i)));
        [ht, wid, ~] = size(next_frames);
        
        % window in next frame to search for the template
        wind_x_min = max(1, target_rect(1) - search_window_size);
        win_x_max = min(wid, target_rect(1) + target_rect(3) + search_window_size);
        win_y_min = max(1, target_rect(2) - search_window_size);
        win_y_max = min(ht, target_rect(2) + target_rect(4) + search_window_size);        
        next_frame_window = next_frames(win_y_min:win_y_max, wind_x_min:win_x_max, :);
        search_range = size(next_frame_window, 1) - target_rect(4) + 1;
    
        % convert search windows to col format.
        next_frame_search_col(:, :, 1) = im2col(next_frame_window(:, :, 1), [target_rect(4), target_rect(3)]);
        next_frame_search_col(:, :, 2) = im2col(next_frame_window(:, :, 2), [target_rect(4), target_rect(3)]);
        next_frame_search_col(:, :, 3) = im2col(next_frame_window(:, :, 3), [target_rect(4), target_rect(3)]);
        
        % next_frame_search_col --> [target_rect(4)*target_rect(3), # of search positions, 3]
        % similarity  --> [# of search positions, 1]
        num_search_positions = size(next_frame_search_col, 2);
        norm_distance = zeros(num_search_positions, 1);
        
        % for all possible arrangements of target box into the search window
        for search_idx = 1 : num_search_positions
            % onverts RGB image to an indexed image using the above colormap
            curr_wind_ind = rgb2ind(next_frame_search_col(:, search_idx, :), template_map);
            curr_wind_hist = histc(curr_wind_ind(:), 1:num_bins);  
            % norm distance metric for similarity.
            norm_distance(search_idx) = norm(template_hist - curr_wind_hist);
        end
        [~, best_match] = min(norm_distance); %index for min norm i.e highest similarity
        
        % find the tagex box coordinates in next frames        
        found_x = ceil(best_match / search_range) + wind_x_min;
        found_y = mod(best_match, search_range) + win_y_min;
        if found_y == win_y_min
            found_y = search_range + win_y_min;
        end
        
        % using the provided drawBox function to draw the found target object
        % The same target object will be used for tracking in the subsequent next frame
        target_rect = [found_x, found_y, target_rect(3), target_rect(4)];
        found_target = drawBox(next_frames, target_rect, [0, 255, 0], 1);
        imwrite(found_target, fullfile(data_params.out_dir, data_params.genFname(i)));
    end
end

