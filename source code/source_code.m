clc;
clear;
close all;

disp("loading... please wait")

% choose image manually
[file,path] = imgetfile;

% read the image
I = imread(file);

% convert to grayscale
I = rgb2gray(I);

% take input of mean and variance
prompt = "What is the value of mean for gaussian noise? (0 by default) ";
mean = input(prompt);
% take default value of 0 if not entered manually
if isempty(mean)
     mean = 0;
end

prompt = "What is the value of variance for gaussian noise? (0.01 by default)";
var = input(prompt);
% take default value of 0 if not entered manually
if isempty(var)
     var = 0.01;
end

% add noise (gaussian) to image
In = imnoise(I, 'gaussian', mean, var);

% choose type of thresholding (hard or soft)
type = 'h';

% input of Daubechies wavelet type (db4, db6,..)
msg = "Choose your Daubechies wavelet";
opts = ["db2", "db4", "db6", "db8"];
choice = menu(msg,opts);

disp("processing... please wait")

% apply 3-level DWT2D (for 2D images)
[cA1, cH1, cV1, cD1] = dwt2(In, opts(choice)); % level - 1
[cA2, cH2, cV2, cD2] = dwt2(cA1, opts(choice)); % level - 2
[cA3, cH3, cV3, cD3] = dwt2(cA2, opts(choice)); % level - 3


%% LEVEL - 3
% find threshold on detail components
T_cH3 = sigthresh(cH3, 3);
T_cV3 = sigthresh(cV3, 3);
T_cD3 = sigthresh(cD3, 3);
% apply threshold, these matrices are denoised before image reconstruction
Y_cH3 = wthresh(cH3, type, T_cH3);
Y_cV3 = wthresh(cH3, type, T_cV3);
Y_cD3 = wthresh(cH3, type, T_cD3);

%% LEVEL - 2
% find threshold on detail components
T_cH2 = sigthresh(cH2, 2);
T_cV2 = sigthresh(cV2, 2);
T_cD2 = sigthresh(cD2, 2);
% apply threshold, these matrices are denoised before image reconstruction
Y_cH2 = wthresh(cH2, type, T_cH2);
Y_cV2 = wthresh(cV2, type, T_cV2);
Y_cD2 = wthresh(cD2, type, T_cD2);

%% LEVEL - 1
% find threshold on detail components
T_cH1 = sigthresh(cH1, 1);
T_cV1 = sigthresh(cV1, 1);
T_cD1 = sigthresh(cD1, 1);

% apply threshold, these matrices are denoised before image reconstruction
Y_cH1 = wthresh(cH1, type, T_cH1);
Y_cV1 = wthresh(cV1, type, T_cV1);
Y_cD1 = wthresh(cD1, type, T_cD1);

% apply inverse discrete wavelet transform on all levels
Y_cA2 = idwt2(cA3, Y_cH3, Y_cV3, Y_cD3, opts(choice));
Y_cA1 = idwt2(cA2, Y_cH2, Y_cV2, Y_cD2, opts(choice));
Y_cA = idwt2(cA1, Y_cH1, Y_cV1, Y_cD1, opts(choice));

figure(1), imshow(I)
figure(2), imshow(In)
figure(3), imshow(uint8(Y_cA))

disp("processing completed")

%% CODE FOR sigthresh() method
%function for finding sigma and threshold
%input: the matrix for which you want to find the threshold
%output : the threshold value 'T'.
function [T] = sigthresh(M, level)
%[a,b] = size(M);
%M is only HH band
C = 0.6745;
variance = (median(abs(M(:)))/C);

beta = sqrt(2*log(length(M))/level);


T = beta*variance;

end