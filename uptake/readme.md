Work in progress

# Notes

## Loading stacks using bfopen

variable = bfopen ('image_name') {you need to be in the directory, or specify it in the image name}

Extract the first


## behaviour of tif files

.tif files from Leica and Olympus systems have the planes for the different channels intercalated. So for a three channel (GFP, Cherry and 647) image of 10 slices, series 1 is GFP(1), series 2 is Cherry(1), series 3 is 647(1), series 4 is GFP(2) and so on until series 30, which is 647(10).
