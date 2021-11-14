function [rgb_stack, gray_stack] = loadFocalStack(focal_stack_dir)
    rgb_stack = [];
    gray_stack = [];
    stack_files = dir(fullfile(focal_stack_dir, 'frame*.jpg'));
    
    % iterate over all stack focus images and create rgb and gray stacks
    for i=1:length(stack_files)
        img = imread(fullfile(focal_stack_dir,stack_files(i).name));
        rgb_stack = cat(3, rgb_stack, img);
        gray_stack = cat(3, gray_stack, rgb2gray(img));
    end
end
