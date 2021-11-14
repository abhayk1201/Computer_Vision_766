function refocusApp(rgb_stack, depth_map)
    % display an image in the focal stack;
    img = rgb_stack(:, :, 1:3);
    [height, width] = size(img, 1:2);
    
    pading = 100;    
    img = padarray(img,[pading pading],255,'both');
    imshow(img);
    
    while true
        % user to choose a scene point using ginput
        [x, y] = ginput(1);        
        x = round(x) - pading;
        y = round(y) - pading;
        %disp(x); disp(y);
        % close application if clicked outside of image, i.e the padded region
        if x <= 0 || y <= 0 || x >= width || y >= height
            break
        end
        
        % Use the index map computed in (a) to facilitate refocusing
        index = depth_map(round(y), round(x));
        img = rgb_stack(:, :, 3*(index-1)+1 : 3*index);
        img = padarray(img,[pading pading],255,'both');
        imshow(img);
    end
    close;
end