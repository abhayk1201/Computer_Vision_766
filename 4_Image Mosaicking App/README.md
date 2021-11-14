# CS766:HW4 
# Abhay Kumar (kumar95)

## challenge1a
- The code uses ginput to provide the source and destination points. I have selected the cornor points to compute the homography matrix
_ In the submitted code, I have fixed the cornor points, which I obtained using ginput.
- src_pts_nx2 = [162.0000  100.0000; 644.0000   98.0000; 640.0000  698.0000; 162.0000  698.0000];
- dest_pts_nx2 = [140.0000  144.0000; 620.0000   28.0000; 664.0000  770.0000; 116.0000  592.0000];
- If you want to use the ginput method, uncomment the code below-
  "UNCOMMENT: TO  SELECT CORNER POINTS using GINPUT"
- Similarly, I have fixed test_points as
test_pts_nx2 = [ 160.0000  102.0000; 348.0000  310.0000; 390.0000  572.0000; 590.0000  506.0000]; Roghly these points are shownn in the expected output image given in the assignment description.

## challenge1b
-Similar to previous part, I have selcted the points using ginput and fixed it in the code for easy re-running & testing purposed.
- portrait_pts = [0.0000   0.0000; 326.0000   0.0000; 326.0000  398.0000; 2.0000  398.0000];
- bg_pts = [100.0000   16.0000; 278.0000   70.0000; 286.0000  424.0000; 84.0000  438.0000];
- I have selected corner point to compute homography.
- used interpol2 in backwardWarpImg.m 


## challenge1c
- I have used the provided code (genSIFTMatches.m) to generate corresponding matching point coordinates from source and destination images.
- For each RANSAC iteration, I randomly (uniform) selected 4 random source and corresponding destination points to compute homography matrix. We keep repeating the same for max iteration count.
- Finally, homography matrix with max inliers is returned. 

## challenge1d
- Code of overlay and blend stitching.
- weighted blending produces much smoother image without any share boundaries as present in overlay stitching.
- I have used `bwdist` to obtaine a weighted mask for blending purpose.

## challenge1e

- Assumption: I assumed the order of the input images matches the order you wish to stitch the images.
- Keep stiching two images at a time and stitch the next with the already stitched output. Do it iteratively for all provided images
- Calculate the bounding box to accomodate pairwise stiched images.
- Filled the destination image using backward warping, using inverse homography matrix. Blend both source and destination images.
- Do above repeatedly till all images are stitched.

## challenge1f
- I have submitted three photos captured from my phone as-
 `cs_left.png`, `cs_center.png`, `cs_right.png`
- The final panorama is stored as `cs_panorama.png`


