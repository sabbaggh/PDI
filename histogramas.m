clc
clear all
close all
warning off all

%leyendo el histograma de una imagen
a=imread('peppers.png');
figure(1)
imhist(a)

%%% generando tu las clases
figure(2)
c1x=randn(1,1000);
c1Y=randn(1,1000);

c2x=randn(1,1000)+10;
c2Y=randn(1,1000)+5;

c3x=(randn(1,1000)+10)*2;
c3Y=(randn(1,1000)+5)*3;

px=input('dame el vector en x=')
py=input('dame el vector en y=')
vect=[px;py]



plot(c1x(1,:),c1Y(1,:),'ro','MarkerSize',10)
grid on
hold on
plot(c2x(1,:),c2Y(1,:),'go','MarkerSize',10)
plot(c3x(1,:),c3Y(1,:),'ko','MarkerSize',10)
plot(vect(1,:),vect(2,:),'sk','MarkerSize',10)


legend('cielo','agua','arena','punto')

disp(' fin de proceso...')