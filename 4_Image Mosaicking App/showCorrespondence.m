function result_img = ...
    showCorrespondence(orig_img, warped_img, src_pts_nx2, dest_pts_nx2)
    fh1 = figure();
    %show original and warped image side-by-side
    imshow([orig_img warped_img]); hold on;
    
    %draw the lines connecting src_pts and dest_pts. 
    for i = 1:size(src_pts_nx2,1)    %LINE ([x_coord], [y_coord])
        line([src_pts_nx2(i,1) size(orig_img,2)+dest_pts_nx2(i,1)], ...
             [src_pts_nx2(i,2) dest_pts_nx2(i,2)],...
             'LineWidth',2, 'Color', [1, 0, 0]);
    end
    result_img = saveAnnotatedImg(fh1);
end
