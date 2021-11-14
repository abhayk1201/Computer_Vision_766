function [inliers_id, H] = runRANSAC(Xs, Xd, ransac_n, eps)
    max_inliers_count = 0;
   
    for iter = 1:ransac_n
        % Randomly select 4 source points and corresponding destination points 
        rand_indices = randi([1 size(Xs,1)],1,4);
        
        % homography matrix from randomly selected points
        H_3x3 = computeHomography(Xs(rand_indices,:), Xd(rand_indices,:));
        
        inlier_count = 0;
        max_inlier_ids = [];
        for i = 1:size(Xs,1)
            % apply the homography to find the destination point
            homogr_Xd = applyHomography(H_3x3, Xs(i,:));
            
            % difference b/c computed and actual destination points
            error = norm(homogr_Xd - Xd(i, :));
            % within eps bound
            if error <= eps
                inlier_count = inlier_count+1;
                max_inlier_ids = [max_inlier_ids; i];
            end
        end
        
        % maintains the best max_inliers_count and inliers_id till i-th RANSAC iterations
        if inlier_count > max_inliers_count
            H = H_3x3;
            inliers_id = max_inlier_ids;
            max_inliers_count = inlier_count;                        
        end
    end
end