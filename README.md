# Keyence-BZX-Z-Stack-Stitching-Macro
Automates stitching of tiled Z-stack images from Keyence microscopes in Fiji. Prompts for grid size and Z-slices, flattens subfolders, runs stitching per slice, handles padding, and outputs a complete 3D stack. Ideal for batch processing multi-tile, multi-slice datasets.


Keyence Z-Stack Stitching Macro SOP 

This SOP outlines how to use the custom ImageJ macro in Fiji to batch-stitch Z-stack images exported from a Keyence BZ-X810 microscope. 

Launch Fiji and Open the Macro 

Open Fiji 

Drag the .ijm macro file into the Fiji interface. 

The macro editor window will appear with the macro code 

Configure Macro Parameters 

Set Grid Dimensions 

Set Z-Slice Count 

Prepare Output Folder 

On your desktop (or preferred location), create a new folder. 

Name the folder: Output_{Project Title} 

Replace {Project Title} with your actual project name. 

Run the Macro 

In the Fiji macro editor, click Run (or press Ctrl + R / Cmd + R).  

When prompted: 

Select Input Folder: Navigate to the parent folder containing all your Keyence image tiles.  

Select Output Folder: Choose the output folder created in Step 3 

Macro Execution and Stitching 

The macro will now:  

Automatically loop through all Z-slices and move them into a new sorted subfolder within the selected output folder 

Stitch the corresponding tile grids 

Convert the RGB Channels to RGB images 

Pad or crop the stitched outputs to ensure consistent dimensions 

Export each stitched Z-slice into a stitched subfolder within the selected output folder 

Monitor Progress 

To track the macro’s progress: 

Go to Fiji > Log to view print messages and warnings.  

Note: The log may remain blank or may not open during the initial sorting phase; this is expected.  

Result 

Once complete, the macro will combine each stitched z-slice image into a stack, creating a “stitched z-stack."  

The stitched output subfolder will also contain each stitched Z-slice image that will all be uniform in size.   
