function [center, radius] = findSphere(img)
    % find centroid and radius using regionprops
    bw_img = im2bw(img, 0.1);
    img_properties = regionprops(bw_img, 'Area', 'Centroid');
    
    center = img_properties.Centroid;
    radius = sqrt(img_properties.Area / pi);
end

