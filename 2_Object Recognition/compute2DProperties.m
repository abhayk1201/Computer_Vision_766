function [db, out_img] = compute2DProperties(orig_img, labeled_img)
    [height, width] = size(orig_img);
    num_obj = max(labeled_img(:));
    num_property = 7;
    db = zeros(num_property, num_obj);
    
    fh1 = figure();
    imshow(orig_img);
    for obj = 1:num_obj
        row_center = 0; column_center = 0; area = 0;
        for row = 1 : height
            for col = 1 : width
                if labeled_img(row, col) == obj
                    row_center = row_center + row;
                    column_center = column_center + col;
                    area = area + 1;
                end
            end
        end
        % taking floor/ceil to have an integer row/column index
        row_center = floor(row_center / area);
        column_center = floor(column_center / area);
       
        %Second moments w.r.t center calculated above (lec-4):
        a = 0; b = 0; c = 0;
        for row = 1 : height
            for col = 1 : width
                if labeled_img(row, col) == obj
                    a = a + ((row - row_center) ^ 2);
                    b = b + (2 * (row - row_center) * (col - column_center));
                    c = c + ((col - column_center) ^ 2);
                end
            end
        end
        
        theta_1 = 0.5 * atand(b / (a - c));
        theta_2 = theta_1 + 90; 
        % fprintf("Orientation: %f\n", orientation);
        E1 = a * sind(theta_1)^2 - b * sind(theta_1) * cosd(theta_1) + c * cosd(theta_1)^2;
        E2 = a * sind(theta_2)^2 - b * sind(theta_2) * cosd(theta_2) + c * cosd(theta_2)^2;

        if E2 <= E1
            E_min = E2; E_max = E1;
            orientation = theta_2;
        else
            E_min = E1; E_max = E2;
            orientation = theta_1;
        end
        
        roundedness = E_min / E_max;
        %fprintf("Center:row %d col %d\nMoments: E_min %f Emax %f\nRoundedness: %f\n",row_center, column_center, E_min, E_max, roundedness);
    
        db(1, obj) = obj;
        db(2, obj) = row_center;
        db(3, obj) = column_center;
        db(4, obj) = E_min;
        db(5, obj) = orientation;
        db(6, obj) = roundedness;
        db(7, obj) = area;
        
        
        hold on;
        % row/column center points
        plot(column_center, row_center, '*', 'MarkerFaceColor', [1 1 0]);
        % orientation Line
        line([column_center column_center + 40 * sind(orientation)], ... 
             [row_center row_center + 40 * cosd(orientation)],...
             'LineWidth', 1.5, 'Color', [0, 0, 1]);     
    end
    
    annotated_img = saveAnnotatedImg(fh1);
    fh2 = figure; imshow(annotated_img);
    delete(fh1); delete(fh2);
    out_img = annotated_img;
end
