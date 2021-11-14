function line_detected_img = lineFinder(orig_img, hough_img, hough_threshold)
    %fprintf("New Image \n\n\n");
    if (hough_threshold == 53)
        wind_theta = 5;
        wind_rho = 1;  %this value works best for hough_2.png
    else
        wind_theta = 5;
        wind_rho = 10;
    end
    [height, width] = size(orig_img);
    [theta_num_bins, rho_num_bins] = size(hough_img);    
    rho_maxm = sqrt(height^2 + width^2);
    fh1 = figure; imshow(orig_img); hold on;
    rho_plotted = [];
    for theta_idx = 1 : theta_num_bins
        for rho_idx = 1 : rho_num_bins
            peak = hough_img(theta_idx, rho_idx);
            if peak > hough_threshold                 
                % Trying to eliminate similar/duplicates edge lines by
                % suppressing local maximas in a small window
                for i = theta_idx - wind_theta  : theta_idx + wind_theta
                    for j = rho_idx - wind_rho : rho_idx + wind_rho
                        if(i > 0 && i <= theta_num_bins && j > 0 && j <= rho_num_bins...
                                && hough_img(i,j) > peak)
                            peak = hough_img(i, j);
                            %fprintf("%d \n ",peak);
                        end
                    end
                end
                %fprintf("SELECTED %d \n ",peak);
                if(peak == hough_img(theta_idx, rho_idx)) 
                    if (~isempty(rho_plotted))
                        % Trying to eliminate similar/duplicates edge lines by
                        % suppressing local maximas in a small window
                        if min(abs(rho_plotted - rho_idx)) >= [3,0]
                            rho_plotted = [rho_plotted, rho_idx];
                            theta = theta_idx * 180 / theta_num_bins;
                            rho = rho_maxm * (rho_idx / (rho_num_bins / 2) - 1);
                            x = 1 : height;
                            % y * cos(theta) = x * sin(theta) + rho
                            y = x * tand(theta) + rho * secd(theta);
                        end
                        %fprintf("PLOTTED theta = %d  rho= %d \n ",theta_idx,rho_idx);
                        plot(y, x, 'Color', [0,1,1],'LineWidth', 5); %(y,x) as per matlab convention
                    else
                        rho_plotted = [rho_plotted, rho_idx];
                        theta = theta_idx * 180 / theta_num_bins;
                        rho = rho_maxm * (rho_idx / (rho_num_bins / 2) - 1);
                        x = 1 : height;
                        % y * cos(theta) = x * sin(theta) + rho
                        y = x * tand(theta) + rho * secd(theta);
                        %fprintf("PLOTTED theta = %d  rho= %d \n ",theta_idx,rho_idx);
                        plot(y, x, 'Color', [0,1,1],'LineWidth', 5); %(y,x) as per matlab convention

                    end
                end
            end
        end
    end
    %use the provided trick to save annotated image.
    line_detected_img = saveAnnotatedImg(fh1);
end