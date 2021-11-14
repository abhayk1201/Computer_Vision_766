function labeled_img = generateLabeledImage(gray_img, threshold)
    fh1 = figure(); 
    imshow(gray_img);
    
    %converts a gray-level image to a binary image
    binary_img = im2bw(gray_img, threshold);
    imshow(binary_img);
    %disp(max(binary_img(:)))
    
    %generate the labeled image.
    labeled_img = bwlabel(binary_img);
    
    fh2 = figure(); 
    imshow(labeled_img);
    %disp(max(labeled_img(:)))
    
    delete(fh1); delete(fh2);
end