function [mask, result_img] = backwardWarpImg(src_img, resultToSrc_H,...
    dest_canvas_width_height)
    
    dest_width = dest_canvas_width_height(1);
    dest_height = dest_canvas_width_height(2);
    result_img = zeros(dest_canvas_width_height(2),dest_canvas_width_height(1),3);
    [y, x] = find(result_img(:,:,1) == 0);
    dest_xy = [x, y];
    % inverse homography on points in the destination image and interpolate
    % corresponding values in the src_img
    homogr_xy = applyHomography(resultToSrc_H, dest_xy);
    result_img(:,:,1) = reshape(interp2(src_img(:,:,1), homogr_xy(:,1), homogr_xy(:,2)), [dest_height, dest_width]);
    result_img(:,:,2) = reshape(interp2(src_img(:,:,2), homogr_xy(:,1), homogr_xy(:,2)), [dest_height, dest_width]);
    result_img(:,:,3) = reshape(interp2(src_img(:,:,3), homogr_xy(:,1), homogr_xy(:,2)), [dest_height, dest_width]);
    
    %interp2 will return NaN for homogr_xy outside the boundary of actual src_img
    result_img(isnan(result_img))=0;
    result_img_gray = rgb2gray(result_img);

    mask = result_img_gray ~= 0;
    %figure; imshow(mask)
end