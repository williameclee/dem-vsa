Z = double(imread('samplemap.tif')).';
Z = Z(round(end / 2):1:end, round(end / 3):1:end);
Z = Z * 2;
Z = -circenvelope2d(-Z, 5);
mapsize = size(Z);

% N = zeros([size(Z), 3]);
[Nx, Ny, Nz] = surfnorm(Z);
N = cat(3,Nx,Ny,Nz);