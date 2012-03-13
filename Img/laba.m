clear
clc
step=3; % ��� ������������
a=imread('F.jpg');
aa=rgb2gray(a);
aaa=fft2(aa);
zz=aaa;
i=step;
figure(1)
imagesc(log(abs(aaa)));
title('������ �� ������������');
colormap gray;
while i<=size(aaa,1)
        aaa(i,:)=[];
        aaa(:,i)=[];
        i=i+step-1;
end
figure(2)
imagesc(log(abs(aaa)));
title('������ ����� ������������');
colormap gray;
figure(3)
imagesc(abs(ifft2(aaa)));
title('����������� ����� ������������');
colormap gray;

[X, Y]=meshgrid(1:size(aaa,1));

[XI, YI]=meshgrid(1:1-1/step:size(aaa,1));

aaa_new=interp2(X,Y,aaa,XI,YI);
figure(4)
imagesc(log(abs(aaa_new)));
title('������ ����� ������������');
colormap gray;
new_img=abs(ifft2(aaa_new));
figure(5)
imagesc(new_img);
title('����������� ����� ������������');
colormap gray;



