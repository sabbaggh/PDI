clc
close all
clear all
warning off all

%mostrar imagen con imshow
a=imread('peppers.png');
figure(1)
imshow(a)
%mostrar imagen con impixel para extraer los datos de los pixeles
figure(2)
clases=impixel(a)
chilitoRojo=clases(1:3,:)
clase2=clases(4:6,:)
clase3=clases(7:9,:)
desconocido=clases(10:end,:)

%se saca la media de cada componente rgb de los pixeles seleccionados
mediaC1 = [mean(chilitoRojo(:,1)) mean(chilitoRojo(:,2)) mean(chilitoRojo(:,3))]
mediaC2 = [mean(clase2(:,1)) mean(clase2(:,2)) mean(clase2(:,3))]
mediaC3 = [mean(clase3(:,1)) mean(clase3(:,2)) mean(clase3(:,3))]

%Se saca la distancia de cada media con respecto al desconocido
dis1=norm(desconocido-mediaC1)
dis2=norm(desconocido-mediaC2)
dis3=norm(desconocido-mediaC3)
%Se ponen las distancias en un vector y se encuentra el minimo, por ultimo
%regresa la columna que mas cerca este
distotal = [dis1 dis2 dis3];
minimo = min(min(distotal));
dato = find(distotal==minimo);

fprintf('El valor desconocido pertenece a la clase %d\n', dato)

%graficando los puntos extraidos de la imagen
figure()
plot3(chilitoRojo(:,1),chilitoRojo(:,2),chilitoRojo(:,3),'ro','MarkerEdgeColor','r','MarkerSize',10)
grid on
hold on
plot3(clase2(:,1),clase2(:,2),clase2(:,3),'go','MarkerEdgeColor','g','MarkerSize',10)
plot3(clase3(:,1),clase3(:,2),clase3(:,3),'bo','MarkerEdgeColor','b','MarkerSize',10)
plot3(desconocido(:,1),desconocido(:,2),desconocido(:,3),'k*','MarkerEdgeColor','k','MarkerSize',10)
legend('clase1','clase2','clase3','desconocido')
disp('fin')









%%%%%%%%%