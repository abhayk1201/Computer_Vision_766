function H_3x3 = computeHomography(src_pts_nx2, dest_pts_nx2)
    %Solve homography equation Ah = 0
    num_points = size(src_pts_nx2,1);
    A = zeros(2*num_points,9);
    x_s = src_pts_nx2(:,1);
    y_s = src_pts_nx2(:,2);
    x_d = dest_pts_nx2(:,1);
    y_d = dest_pts_nx2(:,2);
        
    A(1:num_points, :) = [x_s y_s ones(num_points,1) zeros(num_points,3) -x_d.*x_s -x_d.*y_s -x_d];
    A(num_points+1:end ,:) = [zeros(num_points,3) x_s y_s ones(num_points,1) -y_d.*x_s -y_d.*y_s -y_d];
    
    %eigenvector corresponsing to the shortest eigenvalue solves homography equation Ah = 0
    [V,~] = eigs(A'*A,1,'SM');
    %output homography matrix, reshape V properly
    H_3x3 = reshape(V(:, 1), 3, 3)';
end
