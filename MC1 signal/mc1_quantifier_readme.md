# MC1 Quantifier (v1.0)

This script is designed to segment Or47B neurons expressing GFP and apply the mask to several channels (e.g. GFP, Cherry and MC1)

## Requirements

- The script opens three-channel stacks and requires Bioformats  to implement bfopen.
- Cases should be named 1, 2... in .tif format.
- The Script assumes the channel order is GFP, Cherry and MC1. Edit the lines that make GFP_signal and related arrays if this is not the case.

## Thresholding system
- The current system calculates the average intensity across all slices using the GFP channel.
- It then identifies the slice with the maximum intensity, and applies graythresh on it. The resulting threshold multiplied by 1.5 is used to binaries the whole stack.
- ‘volshow’ allows the inspection of gfpbw binary 3D stacks.

