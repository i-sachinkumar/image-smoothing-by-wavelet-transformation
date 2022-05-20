# image-smoothing-by-wavelet-transformation


## Prerequisites to run the Executable

### Verify that version 9.12 (R2022a) of the MATLAB Runtime is installed.
### Alternatively, download and install the Windows version of the MATLAB Runtime for R2022a 
   from the following link on the MathWorks website:
   https://www.mathworks.com/products/compiler/mcr/index.html




*******************************************************************************************************

#### Output of our sample input is added in result folder in which:
** noise was added by gaussian noise with mean=0, variance=0.01
<br>
** tranformation was done with "db4" Daubechies wavelet

<h1> Original image (img1) </h1>
<img src="sample%20results%20for%20db4/output_1_img1.png"/>

<br>

<h1> Added gaussian noise (img2) </h1>
<image src="sample%20results%20for%20db4/output_1_img2.png"></image>

<br>

<h1> Image reconstruction with wavelet transformation (img3) </h1>
<image src="sample%20results%20for%20db4/output_1_img3.png"></image>


  
#### Interpretation:
** img2 will look very noisy, guassian noise is added, <br>
** but img3 will look somewhat like img1(original image), less noisy. because it is denoised by wavelet transformation
