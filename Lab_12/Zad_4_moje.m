clear all; close all;

img = double( imread( 'lena512.png' ) );
q = 80;
bits = jpegCode( img, q );
out = jpegDeCode( bits );
figure; imagesc( img ); colormap gray;
figure; imagesc( out ); colormap gray;

num_bits = length(bits) - 3*16;
num_pixels = 512*512;

bit_per_pixel = num_bits/num_pixels