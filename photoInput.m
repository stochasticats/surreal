function [imgmtx,imgvec,Nrows,Ncols] = photoInput(imgfile)
% Convert an image file (jpg) to a matrix

% Jamie Nordio

%  read image & convert to grayscale matrix
my_imgC = imread(imgfile,'jpeg');
my_imgG = imrotate(fliplr(transpose(im2double(rgb2gray(my_imgC)))),90);

figure(900);  clf
imagesc(my_imgG);  colormap('gray')
axis equal
axis image
print -djpeg90 img.jpg

img_size = size(my_imgG);
Nrows = img_size(1);
Ncols = img_size(2);

%  change image matrix into a column vector
imgvec = reshape(my_imgG,Nrows*Ncols,1);
imgmtx = my_imgG;

%
%  NOTE:  to restore vector to matrix (Nrows,Ncols)
%	Nrows = 320;  Ncols = 240;
%	mtx = reshape(imgvec,Nrows,Ncols);
%

[uu,ss,vv] = svd(my_imgG,0);

figure(901);  clf
SVs = diag(ss);
plot(log10(SVs),'k.');  hold on;  grid on
title(['\bf singular values'],'fontsize',16)
ylabel(['\bf log_{10} singular values'],'fontsize',14)
xlabel(['\bf largest to smallest (total  = ' num2str(min(img_size)) ')'],'fontsize',14)

return
