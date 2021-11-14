function stitched_img = stitchImg(varargin)
    stitched_img = varargin{1};
    
    % Use RANSAC to reject outliers
    ransac_n = 50; % Max number of iteractions
    ransac_eps = 2; % Acceptable alignment error  
    
    for i = 2:size(varargin, 2)
        %stitched_img = stitchImgUtil(varargin{i+1}, stitched_img);
        src_img = varargin{i};
        [src_img_height, src_img_width] = size(src_img, 1:2);
        dest_img = stitched_img; %stitched image till i-th iteration
        
        % compute the bounding box (largest rectangle needed for stiched image)
        [X_s, X_d] = genSIFTMatches(src_img, dest_img);
        [~, H] = runRANSAC(X_s, X_d, ransac_n, ransac_eps);
        
        src_img_corners = [[1 1];[src_img_width 1];[1 src_img_height];[src_img_width src_img_height]];
        dest_img_corners = applyHomography(H, src_img_corners);

        x_min = min(1, round(min(dest_img_corners(:,1))));
        x_max = max(round(max(dest_img_corners(:,1))), size(dest_img, 2) + abs(x_min));
        y_min = min(1, round(min(dest_img_corners(:,2))));
        y_max = max(round(max(dest_img_corners(:,2))), size(dest_img, 1) + abs(y_min));

        % bounding box (after homography) to be stitched finally 
        warped_dest_img = zeros(round(y_max - y_min), round(x_max - x_min), 3);
        [warped_dest_img_ht, warped_dest_img_wd] = size(warped_dest_img, 1:2);
        
        % backward warping of dest image
        [warped_src_mask, warped_src_img] = backwardWarpImg(src_img, ...
                            inv([1 0 abs(x_min);0 1 abs(y_min);0 0 1]*H), ...
                            [warped_dest_img_wd warped_dest_img_ht]);

        warped_dest_img(abs(y_min):abs(y_min) + size(dest_img,1) - 1, abs(x_min):abs(x_min) ...
                             + size(dest_img,2) - 1, :) = dest_img;

        warped_dest_mask = rgb2gray(warped_dest_img) ~= 0;
        % Blend src and dest image
        stitched_img = blendImagePair(warped_src_img, warped_src_mask, warped_dest_img, ... 
                                       warped_dest_mask, 'blend'); 
    end
end





% function stitched_img = stitchImg(varargin)
%     % RANSAC parameters:
%     ransac_n = 30;         % Max number of iteractions
%     ransac_eps = 2;        % Acceptable alignment error 
% 
%     reference_img = varargin{ceil(nargin / 2)};
%     for img_idx = 1 : nargin
%         if img_idx ~= ceil(nargin / 2)
%             img = varargin{img_idx};
%             
%             [xs, xd] = genSIFTMatches(img, reference_img);
%             
%             [~, H_3x3] = runRANSAC(xs, xd, ransac_n, ransac_eps);
%             
%             [img_ht, img_wid, ~] = size(img);
%             src_corners = [1, 1; img_wid, 1; img_wid, img_ht; 1, img_ht];
%             dest_corners = applyHomography(H_3x3, src_corners);
%             
%             % Compute the bounding box for destination img:
%             % If img is left to center, left append zeros.
%             % Else, right append
%             tx = 0; ty = 0;
%             if img_idx < ceil(nargin / 2)
%                 min_x = round(min(dest_corners(:, 1)));
%                 if min_x < 0
%                     % fprintf("Extending left\n");
%                     tx = -min_x;
%                     reference_img = horzcat(zeros(size(reference_img, 1), -min_x, 3), reference_img);
%                 end
%             else
%                 max_x = round(max(dest_corners(:, 1)));
%                 if max_x > size(reference_img, 2)
%                     % fprintf("Extending right\n");
%                     reference_img = horzcat(reference_img, zeros(size(reference_img, 1), max_x - size(reference_img, 2), 3));
%                 end
%             end
%             min_y = round(min(dest_corners(:, 2)));
%             max_y = round(max(dest_corners(:, 2)));
%             initial_ref_ht = size(reference_img, 1);
%             if min_y < 0
%                 % fprintf("Extending up\n");
%                 ty = -min_y;
%                 reference_img = vertcat(zeros(-min_y, size(reference_img, 2), 3), reference_img);
%             end
%             if max_y > initial_ref_ht
%                 % fprintf("Extending down\n");
%                 reference_img = vertcat(reference_img, zeros(max_y - initial_ref_ht, size(reference_img, 2), 3));
%             end
%             
%             dest_canvas_wid_ht = [size(reference_img, 2), size(reference_img, 1)];
%             % figure('Name', 'Reference Img'), imshow(reference_img);
%             
%             % The new homography = translation homography * old homography
%             H_new = [1, 0, tx; 0, 1, ty; 0, 0, 1] * H_3x3;
%             
%             [mask, res_img] = backwardWarpImg(img, inv(H_new), dest_canvas_wid_ht);
%             % figure('Name', 'Warped img'), imshow(res_img);
%             mask_ref = reference_img(:, :, 1);
%             mask_ref(reference_img(:, :, 1) > 0) = 1;
%             % figure('Name', 'Mask'), imshow(mask);
%             % figure('Name', 'Mask Ref'), imshow(mask_ref);
%             reference_img = blendImagePair(res_img, mask, reference_img, mask_ref, 'blend');
%             reference_img(isnan(reference_img)) = 0;
%             % figure('Name', 'After Blending'), imshow(reference_img);
%         end
%     end
%     stitched_img = reference_img;
% end
