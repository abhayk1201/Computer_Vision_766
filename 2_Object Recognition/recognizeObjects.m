function output_img = recognizeObjects(orig_img, labeled_img, obj_db)
    
    [test_obj_db, ~] = compute2DProperties(orig_img, labeled_img);   
    fh1 = figure(); imshow(orig_img);

    %compare properties of each object in test image with properties of objects in model database
    for test_obj = 1 : size(test_obj_db,2)
        for model_obj = 1 : size(obj_db,2)
            
            test_obj_prop = test_obj_db(:, test_obj);
            model_db_obj_prop = obj_db(:, model_obj);
            

            E_min_percent_diff = abs(test_obj_prop(4) - model_db_obj_prop(4)) / model_db_obj_prop(4);
            if abs(test_obj_prop(6) - model_db_obj_prop(6)) < 0.03 && E_min_percent_diff < 0.15
                
                % Plot Center and Orientation Line
                hold on;
                plot(test_obj_prop(3), test_obj_prop(2), '*', 'MarkerFaceColor', [1 1 0]);
                line([test_obj_prop(3) test_obj_prop(3) + 40 * sind(test_obj_prop(5))], ...
                     [test_obj_prop(2) test_obj_prop(2) + 40 * cosd(test_obj_prop(5))],...
                    'LineWidth', 1.5, 'Color', [0, 0, 1]);
            end
        end
    end
    
    output_img = saveAnnotatedImg(fh1);
    fh2 = figure; imshow(output_img);
    delete(fh1); delete(fh2);
end
