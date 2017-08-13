% Gaussian blur on image using Fast Fourier Transform
% script will prompt user for the filename of image they wish to
% apply Gaussian blur to
%requires photoInput.m

% Jamie Nordio

clear;

% read in image file (jpg please!)
filename = input('filename of .jpg:  ','s');

if (filename(end-3:end)=='.jpg')
	[imgmtx, imgvec, Nrows, Ncols] = photoInput(filename);
	close(901)
else
	disp('filename error, must end with .jpg')
end

% check dimensions to resize image to even number of rows/cols
if (floor(Nrows/2)*2~=Nrows)
	imgmtx = imgmtx(1:end-1,:);
	Nrows = Nrows-1;
	disp('resized image to even # of rows')
end
	
if (floor(Ncols/2)*2~=Ncols)
	imgmtx = imgmtx(:,1:end-1);
	Ncols = Ncols-1;
	disp('resized image to even # of cols')
end

%  take 2D fft
imgfft = fftshift(fft2(imgmtx));

%  real-valued by-products
imfcos = real(imgfft);
imfsin = imag(imgfft);
imfabs =  abs(imgfft);

%  fourier mode numbers & mask matrices
kk = [-(Ncols/2):(Ncols/2)-1];
ll = [-(Nrows/2):(Nrows/2)-1];

[kg, lg] = meshgrid(kk,ll);

%  look at the results
figure(904)
imagesc(kk,ll,     log(imfabs));

cmax = max(log(imfabs(:)));
cmin = min(log(imfabs(:)));
caxis([cmin cmax])

colormap(flipud(hot));  colorbar
axis equal;  axis image
title(['\bf log|c_j| coefficents for ' filename],'fontsize',14)
xlabel(['\bf k-axis'],'fontsize',12)
ylabel(['\bf l-axis'],'fontsize',12)

%  partial fourier reconstruction

%  Gaussian blur
sigma = 4;
mask = ((1/2)*pi*sigma^2) .* exp(-1/(2*sigma^2) * (kg.^2 + lg.^2));

%  reconstruction
newfft = mask.*imgfft;
newimg = real(ifft2(fftshift(newfft)));

figure(904);  clf
imagesc(newimg);  colormap('gray')
axis equal
axis image

%  look at masked coefficients
figure(905)
imagesc(kk,ll, log(abs(newfft)));

caxis([cmin cmax])
colormap(flipud(hot));  colorbar
axis equal;  axis image
title(['\bf log|c_j| coefficents for masked img'],'fontsize',14)
xlabel(['\bf k-axis'],'fontsize',12)
ylabel(['\bf l-axis'],'fontsize',12)
