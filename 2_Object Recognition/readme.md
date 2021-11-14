# CS766 HW2

## Walkthrough 1:
-	Threshold value of 0.4 seems to works well for im2bw conversion.
-	Number of dilations/erosions = 5 works well for noise removal.
-	Number of erosions/dilations = 10 works well for removing rices.

## Challenge 1a:
-	threshold_list = [0.5, 0.5, 0.5] for im2bw for all three images

## Challenge 1b:
-	I added 'area of object' as the 7th (new) property in objects db.

## Challenge 1c1 & 1c2: 
-	I used combination of roundedness and second moment (E_min) as the criteria to compare test image objects with the model object database. I set the threshold as '0.03' for roundedness, objects having roundedness within this threshold is likely to be the same object. Additionally, I also used second moment of inertia as well with fractional change of '0.15' threshold. i.e. E_min of model object and test_object can't vary more than 15% to be identified as the same object. 