clear
clc
v0=0;
v1=pi/2;
v2=pi; 
v3=3*pi/2;
v4=2*pi;

a=imread('F.jpg');
a_gr=rgb2gray(a);
spect=fft2(a_gr);
zz=spect;

x0=floor(size(spect,2)*v0/(2*pi))+1;
y0=floor(size(spect,1)*v0/(2*pi))+1;

x1=floor(size(spect,2)*v1/(2*pi));
y1=floor(size(spect,1)*v1/(2*pi));

x2=floor(size(spect,2)*v2/(2*pi));
y2=floor(size(spect,1)*v2/(2*pi));

x3=floor(size(spect,2)*v3/(2*pi));
y3=floor(size(spect,1)*v3/(2*pi));

x4=floor(size(spect,2)*v4/(2*pi));
y4=floor(size(spect,1)*v4/(2*pi));



spect_4=spect;
spect_4(x0:x3,y0:y3)=0;


spect_3=zeros(size(spect,1),size(spect,1));
spect_3((x0:x3,y0:y3)=spect(x0:x3,y0:y3);
spect_3(x0:x2,y0:y2)=0;

spect_2=zeros(size(spect,1),size(spect,1));
spect_2((x0:x2,y0:y2)=spect(x0:x2,y0:y2);
spect_2(x0:x1,y0:y1)=0;

spect_1=zeros(size(spect,1),size(spect,1));
spect_1((x0:x1,y0:y1)=spect(x0:x1,y0:y1);



new_img1=abs(ifft2(spect_1)); %картинка, полученная из первой области спектра

figure(1)
imagesc(a);
title('Изображение до фильтрации');
colormap gray;

figure(2)
imagesc(new_img);
title('Изображение после фильтрации');
colormap gray;










