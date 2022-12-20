Work in progress

# Instructions

1. Download the whole uptake folder
 
2. Preprocess images for the assay
 - Files must be ".tif"
 - Files must be numbered from 1 to end, with no gaps
 - Files have the same channel order
 
3. run "uptake_preprocessing.m" to generate average and maximum projections.
4. Use Tissue analyzer (Fiji) to generate segmentation masks of the cell borders contained inside a folder named as "number.tif".
5. Run 

# Notes

## Loading stacks using bfopen

variable = bfopen ('image_name') {you need to be in the directory, or specify it in the image name}

Extract the first


## behaviour of tif files

.tif files from Leica and Olympus systems have the planes for the different channels intercalated. So for a three channel (GFP, Cherry and 647) image of 10 slices, series 1 is GFP(1), series 2 is Cherry(1), series 3 is 647(1), series 4 is GFP(2) and so on until series 30, which is 647(10).
