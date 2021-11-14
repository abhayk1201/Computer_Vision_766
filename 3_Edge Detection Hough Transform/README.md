
# CS766 HW3
## Abhay Kumar, kumar95


## walkthrough1

- Sobel edge detection using thresh = 0.11; Using lower threshold given many more extra edge points
- Canny edge detection using thresh = 0.2; Using lower threshold given many more extra edge points


## challenge1a

- find the edge pixels in the image using the built-in 'canny' edge function. I used the threshold values {0.09, 0.13, 0.13} for three different images. 
- I experimented with lower threshold values {0.06, 0.08, 0.08};  It gives many extraneous edge pixels.


## challenge1b 

- Image sizes for hough_1, hough_2, and hough_3 are (426 x 640), (480 x 640), and (480 x 640) respectively. 
- diagonal distance it sqrt(480^2 + 640^2) = 800. That means the maximum value of `rho` can be 800 on both sides of origin.
  -800  <= `rho`  <= 800. 
- I experimented with different `rho_num_bins` to have `rho_bin_size` < 1 and and < 2. Experimentally, I fixed it  `rho_num_bins` to 1800.
- `theta` ranges from 0 to 180 degrees. I experimented with `theta_num_bins` values as 180, 240, 360. Finally, I choose 240.
- Effectively, one bin of `theta` covers 0.75 degrees and one bin of `rho` ~ 0.9 distance unit.

- Chosen bins resolution is neither too high resolution or low resolution. It makes it redundant to have a `voting scheme`. I just used each bin in the accumulator image than a patch of bins. I tried with different resolutions of bins for both `theta` and `rho`. However, for the next part, I tried with voting within a patch of few `rho` and `theta` bins to avoid local maximas.


## challenge1c

-I have used standard threshold to find the peaks in the accumulator array. If the accumulator pixel value is greater than `hough_threshold`, it represents an edge line with that particular (rho, theta). After fine-tuning, I chose hough_threshold = [60 53 50]. I tried with different values for different choices in challenge1a and challenge1b too. All those choices are commented out in the runHw3.m code.

-I have also experimented with suppressing non-maxima in a given patch. Choosing the patch size is tricky as well. Choosing higher patch size maay suppress two distinct peaks, corresponding to two different edges. 

- I have to choose different patch size for hough_2.png (5 theta_bins, 1 rho_bins). Choosing more than 1 rho_bins patch size, many horizonal edges disapper. For other two images, I choose patch size as (5 theta_bins, 10 rho_bins). 

- It's hard to tune all parameters and threshold to remove all duplicate edge lines. 

For `hough_2.png`, If I try to remove middle (two horizontal lines) duplicate lines, the top edge disappears. This image is the HARDEST to suppress the duplicates/similar lines. 


## challenge1d

- I use the standard threshold method with hough_threshold = [100 50 50]. I tried with different values for different choices in challenge1a and challenge1b too. All those choices are commented out in the runHw3.m code.

- We get all possible edge lines from `challenge1c`, we need to figure out the end-points of a edge line segments. We can used the edge pixels location to figure out the end-points. However, the edge pixels doesn't perfectly lie on a line, it may be off by few pixels depending on the bin sizes that we chose for our accumulator arrays and the hough_threshold. To counter this, I used dilation `bwmorph` operation to dilate the edge pixels, so that we can keep increasing the line segment as long as the pixels are part of the dilated edge. 
We start with a non-zero dilated edge point and keep inreasing by 0.01 along x-axis and corresponding y-axis increment based on the peak (theta, rho) values, as long as the (x,y) pairs on line are still part of the dilated edge points. 

- Above method was the easiest to implement, I tried to suppress duplicates edge lines or overlapping edge lines, but it requires significant parameter tuning and cases. Basically, I need a method to check if the edge pixels contributed to the edge line that we are considering, and figure the start and end points. We can use neighborhood voting or convolution (centered at pixel on line) or dilation approach to figure out if the edge pixels is part of the same line or not. If not, we segment the line after figuring the end-point.