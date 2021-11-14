CS766: HW7
Abhay kumar (kumar95)


## challenge1a
- compute the optical flow needle map.
- used `normxcorr2` function to compute the normalized cross-correlation of the template and search window. 
 
 Parameters used:
 	- search_half_window_size = 36;   % Half size of the search window
	- template_half_window_size = 24; % Half size of the template window 
	- [m,n] = size(img_stack{1});  % [240, 360]
	- grid_MN = [m/16, n/16];   % Number of rows and cols in the grid = [24, 36] 
            


## challenge2

- Used color histogram based object tracking system. 
	- choose a template object to track and compute its color map and histogram. 
	- determine a search window around the template object in the previous image 
	- compute the color histogram of all possible arrangements of template window in 	   the search window. 
	- Minimum distance both histograms (target template and search template window)    
	  will give the new location of the template object.Then we update the location and execute the same process in the next image. 

- complete tracking video for frames 1 to 250 is present in the respective output folders.
 
 **./walking_person_result/output_full_video.avi**
 **./rolling_ball_result/output_full_video.avi**
 **./basketball_result/output_full_video.avi**


- Parameters used for tracking
	- walking person
		tracking_params.rect = [196 68 39 119]
		tracking_params.search_half_window_size = 10;
		tracking_params.bin_n = 32

	- rolling ball
		tracking_params.rect = [158 132 45 45]
		tracking_params.search_half_window_size = 10;
		tracking_params.bin_n = 32

	- basketball
		tracking_params.rect = [314 232 33 77]
		tracking_params.search_half_window_size =7;
		tracking_params.bin_n = 32
