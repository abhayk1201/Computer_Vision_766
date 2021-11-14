CS766: HW6
Abhay kumar (kumar95)


## challenge1a
- Load the focal stack frames. The order of frames inside the `rgb_stack` or `gray_stack` are not in any particular order (like from frame1 to frame25), but both stacks have same order (as the order matlab reads the directory) https://piazza.com/class/kk2x7b66u0x77b?cid=190 

## challenge1b

- I choose half_window_size = 15 to smoothen the computed focus measure.

- Once we have the index image, it's not continuous, i.e neighbouring pixels can have abrupt changes in its index. Gaussian smoothing of the index map gives a more smoother version.

- We can have a MODE filter, that in a window_size, choose the index which occurs the most in the window_size of the given pixel location. Commented out this code block, as it is not vectorized form and take few seconds.

- We can also use Median filter to choose the median index value in the window_size neighbourhood of the pixel location.

-  %MEDIAN FILTER
   % index_map = medfilt2(index_map, [10 10]);
   
-  Uncommenting this will give much better and continuous index map.
   But, I was not sure if `medfilt2` is allowed for the hw or not.
