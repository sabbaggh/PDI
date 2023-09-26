clc
clear all
close all
warning off all

figure()
h=imread('bandera.jpg');
[m,n]=size(h);
imshow(h)

figure()
dato=imref2d(size(h)); %imref2d cambia coordenadas del plano a coordenadas reales de la imagen
imshow(h,dato)

% seleccionando las clases presentes en la imagen
c1y=randi([1,350],1,100);
c1x = randi([1,200],1,100);
c1=[c1x,c1y];

c2y = randi([1,350],1,100);
c2x =  randi([220,400],1,100);
c2=[c2x,c2y];

c3y = randi([1,350],1,100);
c3x =  randi([430,600],1,100);
c3=[c3x,c3y];

px = input('dame las coord del punto en x = ')
py = input('dame las coord del punto en y = ')

punto = [px;py];
%graficando sobre el plano de la imagen en coordenadas pixelares
z1=impixel(h,c1x(1,:),c1y(1,:));
z2 = impixel(h,c2x(1,:),c2y(1,:));
z3 = impixel(h,c3x(1,:),c3y(1,:));
p1=impixel(h,px(1,:),py(1,:));
grid on
hold on
plot(c1x(1,:),c1y(1,:),'ro','MarkerSize',10,'MarkerFaceColor','r')
plot(c2x(1,:),c2y(1,:),'bo','MarkerSize',10,'MarkerFaceColor','b')
plot(c3x(1,:),c3y(1,:),'go','MarkerSize',10,'MarkerFaceColor','g')
plot(punto(1,:),punto(2,:),'mo','MarkerSize',10,'MarkerFaceColor','m')

legend('pure','frijoles','pechuga')

media1 = mean(c1,2)
media2 = mean(c2,2)
media3 = mean(c3,2)

dist1 = norm(c1-punto);
dist2 = norm(c2-punto);
dist3 = norm(c3-punto);

dist_total=[dist1 dist2 dist3];
minimo = min(min(dist_total));
dato = find(dist_total==minimo)
disp('fin de programa')