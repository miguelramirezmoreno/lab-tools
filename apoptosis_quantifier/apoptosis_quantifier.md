# Apoptosis Quantifier (v1.0)

This script is designed to analyze cell death at the wing disc.

## Requirements

- The script opens three-channel projections and analyses the third channel. It requires Bioformats  to implement bfopen.
- Cases should be named 1, 2... in .tif format.
- Three folders are required: "avg_basal" (actual images to analyze), "mask_cherry" (binary image of the posterior compartment mask), and "mask_pouch" (mask for all the tissue to be analyzed, anterior and posterior compartment).
- input format can be changed in line 32, resolution of the image (pixels per um)in line 35.

## Future updates

-  Optimize the processing as for some images the threshold is not good. The script generates binary masks for all the segmented images, so manual inspection is encouraged.
-  The script will be adapted also to quantify proliferation.
