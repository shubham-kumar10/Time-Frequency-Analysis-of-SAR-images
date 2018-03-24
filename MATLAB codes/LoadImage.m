function [Image,im_qp] = LoadImage()
% gffquickview open and view Sandia GFF image file
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% This software is provided as is, with no guarantee,
%% warranty, or other assurance of functionality or
%% correctness for any purpose. Furthermore, users should
%% have no expectation of support from the authors or
%% Sandia National Laboratories. Use at your own risk.
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Author: A. W. Doerry, 5342
% Written: 28March2006
% Copyright: 2006 Sandia National Laboratories

% awd 20060328 initial coding
%
clc
clear all;
close all;
pathname = 'MiniSAR20050519p0001image008.gff';
[Image, Header, fname] = load_gff_1_8b('defaultPath',pathname);
if Header.BytesPerPixel>1,
 im_qp = sqrt(abs(Image));
else
 im_qp = abs(Image);
end
im_qp = 255*im_qp/max(max(im_qp));
im_qp = round(min(4*im_qp,255));
figure; image(im_qp);
colormap(gray(256));
axis('image');
end