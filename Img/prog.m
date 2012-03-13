clear
clc
v1=1; %нижняя граница фильтра
v2=2*pi; %верхняя граница фильтра
a=imread('F.jpg');
a_gr=rgb2gray(a);
spect=fft2(a_gr);
zz=spect;

x1=floor(size(spect,2)*v1/(2*pi))+1;
y1=floor(size(spect,1)*v1/(2*pi))+1;

x2=floor(size(spect,2)*v2/(2*pi));
y2=floor(size(spect,1)*v2/(2*pi));

fltr=spect(x1:x2,y1:y2);
spect_new=zeros(size(spect,1),size(spect,1));
spect_new(x1:x2,y1:y2)=fltr;

new_img=abs(ifft2(spect_new));
figure(1)
imagesc(a);
title('Изображение до фильтрации');
colormap gray;

figure(2)
imagesc(new_img);
title('Изображение после фильтрации');
colormap gray;










