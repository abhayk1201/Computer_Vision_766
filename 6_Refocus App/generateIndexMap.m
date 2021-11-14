function index_map = generateIndexMap(gray_stack, w_size)
    focus_measure = [];
    
    for i = 1:size(gray_stack,3)
        img = gray_stack(:,:,i);
        
        % use the modified Laplacian (described in the lecture) as the focus measure.
        laplacian_filter = [-1 2 -1];        
        laplacian_x = imfilter(img, laplacian_filter, 'replicate', 'conv');
        laplacian_y = imfilter(img, laplacian_filter', 'replicate', 'conv');
        lap_map = abs(laplacian_x) + abs(laplacian_y);
        
        % smooth the data (e.g., with a moving average filter)
        average_filter = fspecial('average', 2*w_size+1);
        lap_map = imfilter(lap_map, average_filter, 'replicate');
        focus_measure = cat(3, focus_measure, lap_map);
    end
    

    % choose the layer with the maximum focus measure as the best focused layer.
    % The integer intensity of each pixel indicates the index of the 
    % best focused layer associated with the corresponding scene point.
    [~,index_map] = max(focus_measure,[], 3);
    
    
    % Gassian FILTER
    H = fspecial('gaussian', [10 10]);
    index_map = imfilter(index_map, H,'replicate');
    
    
    %MEDIAN FILTER
    index_map = medfilt2(index_map, [10 10]);

    
%     % MODE FILTER 
%     win = 5;
%     for i =win+1 : size(index_map,1)-win
%         for j =win+1 : size(index_map,2)-win
%             wind = index_map(i-win:i+win, j-win:j+win);
%             index_map(i,j) = mode(wind(:));
%         end
%     end
       
end
