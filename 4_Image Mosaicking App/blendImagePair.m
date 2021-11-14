function out_img = blendImagePair(wrapped_imgs, masks, wrapped_imgd, maskd, mode)

    masks = masks > 0; %same as logical(masks)
    maskd = maskd > 0; %same as logical(maskd)
    
    if mode == "overlay"
        % copy destination image over soure image wherever the mask2 applies.
        out_img = im2double(wrapped_imgs) .* ~cat(3, maskd, maskd, maskd) + im2double(wrapped_imgd);
        % ~cat(3, maskd, maskd, maskd) is not needed actually, just multiply by maskd
        
    elseif mode == "blend"
        masks = bwdist(~masks);
        bl_masks = masks ./ max(masks(:));
        
        maskd = bwdist(~maskd);
        bl_maskd = maskd ./ max(maskd(:));
        
        % perform weighted blending
        out_img = (im2double(wrapped_imgs) .* bl_masks + im2double(wrapped_imgd) .* bl_maskd) ./ (bl_masks + bl_maskd);
        out_img(isnan(out_img)) = 0;

    end
end

