function dest_pts_nx2 = applyHomography(H_3x3, src_pts_nx2)
    
    %add third fictitious coordinate as 1 
    src_pts_nx2_homg = [src_pts_nx2 ones(size(src_pts_nx2, 1), 1)]; %each row is one point
    dest_pts_nx2_homg = (H_3x3 * src_pts_nx2_homg')';   %each row is a point 
    
    %convert back to 2-D coordinte by dividing by fictitious coordinate 
    fict_coord = dest_pts_nx2_homg(:,3);
    dest_pts_nx2 = dest_pts_nx2_homg(:,1:2)./fict_coord;
end