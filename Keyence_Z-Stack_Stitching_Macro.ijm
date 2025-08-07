// === USER INPUT DIALOG ===
Dialog.create("Enter Stitching Parameters");
Dialog.addNumber("Grid Size X:", 5);
Dialog.addNumber("Grid Size Y:", 5);
Dialog.addNumber("Total Z Slices:", 25);
Dialog.show();

gridSizeX = Dialog.getNumber();
gridSizeY = Dialog.getNumber();
totalZSlices = Dialog.getNumber();

// === OTHER USER SETTINGS ===
tileOverlap = 30.0;
channel = "CH4";
projectName = "MyProject";

// ======================
// Select source and output directories
sourceDir = getDirectory("Select folder containing Z-stack subfolders");
outputBase = getDirectory("Select output base directory");

// Create a folder to hold all images together
sortedDir = outputBase + "All_Tiles_Flat_" + projectName + "/";
File.makeDirectory(sortedDir);

// Copy all images from subfolders into one folder
list = getFileList(sourceDir);
for (i = 0; i < list.length; i++) {
    path = sourceDir + list[i];
    if (File.isDirectory(path)) {
        files = getFileList(path);
        for (j = 0; j < files.length; j++) {
            if (endsWith(files[j], ".jpg") || endsWith(files[j], ".tif") || endsWith(files[j], ".png")) {
                fromPath = path + File.separator + files[j];
                toPath = sortedDir + files[j];
                File.copy(fromPath, toPath);
            }
        }
    }
}
print("Finished copying images to: " + sortedDir);

// Create output subfolder
outputDir = outputBase + "Stitch_ParentFolder_" + projectName + "/";
File.makeDirectory(outputDir);

// Store reference image size
refWidth = -1;
refHeight = -1;

for (z = 1; z <= totalZSlices; z++) {
    zStr = IJ.pad(z, 3);
    pattern = "1x_XY{ii}_Z" + zStr + "_" + channel + ".tif";
    configName = "TileConfiguration_" + zStr + ".txt";
    outputName = "Stitched_Z" + zStr + ".tif";

    // Build stitching command
    cmd = "";
    cmd += "type=[Grid: snake by rows] ";
    cmd += "order=[Right & Down                ] ";
    cmd += "grid_size_x=" + gridSizeX + " ";
    cmd += "grid_size_y=" + gridSizeY + " ";
    cmd += "tile_overlap=" + tileOverlap + " ";
    cmd += "first_file_index_i=1 ";
    cmd += "directory=[" + sortedDir + "] ";
    cmd += "file_names=" + pattern + " ";
    cmd += "output_textfile_name=" + configName + " ";
    cmd += "fusion_method=[Linear Blending] ";
    cmd += "regression_threshold=0.30 ";
    cmd += "max/avg_displacement_threshold=2.50 ";
    cmd += "absolute_displacement_threshold=3.50 ";
    cmd += "compute_overlap ";
    cmd += "subpixel_accuracy ";
    cmd += "image_output=[Fuse and display]";

    // Run the stitching plugin
    run("Grid/Collection stitching", cmd);

    // Only proceed if stitching produced an image
    if (nImages > 0) {
        run("RGB Color");

        // Get current stitched image dimensions
        currentWidth = getWidth();
        currentHeight = getHeight();

        // Save first slice's dimensions as reference
        if (refWidth == -1 && refHeight == -1) {
            refWidth = currentWidth;
            refHeight = currentHeight;
        }

        // Check if current image matches reference size
        if (currentWidth != refWidth || currentHeight != refHeight) {
            // Copy current image
            run("Copy");

            // Create blank image with reference size
            newImage("Padded", "RGB black", refWidth, refHeight, 1);

            // Paste current image at 0,0
            makeRectangle(0, 0, currentWidth, currentHeight);
            run("Paste");

            // Save the padded image
            saveAs("Tiff", outputDir + outputName);
            close(); // close Padded
            selectWindow("Fused");
            close(); // close original stitch
        } else {
            // Save directly if size matches
            saveAs("Tiff", outputDir + outputName);
            close();
        }
    } else {
        print("Stitching failed for Z = " + zStr + ": no image generated");
    }
}

// === Now import the stitched slices as an image sequence
run("Image Sequence...",
    "open=[" + outputDir + "] " +
    "sort use " +
    "starting=1 " +
    "increment=1 " +
    "scale=100 " +
    "file=[] " +
    "or=[]");
