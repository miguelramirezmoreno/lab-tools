
img_name=getTitle();
direc= getDirectory("Choose a Directory");
run("Z Project...", "projection=[Max Intensity]");

run("Split Channels");

run("Merge Channels...", "c2=[C1-MAX_"+img_name+"] c6=[C2-MAX_"+img_name+"] create");
run("RGB Color");
saveAs("Tiff", direc+img_name+"_RGB");
close();
run("Split Channels");
run("Invert");
run("Grays");
run("RGB Color");
saveAs("Tiff", direc+img_name+"_Tau");
close();
run("Invert");
run("Grays");

run("RGB Color");
saveAs("Tiff", direc+img_name+"_GFP");
close();
close();
