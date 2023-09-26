clc
clear all
close all
warning off all

h=imread('peppers.png');
[m,n]=size(h);
clases = input('Ingrese el numero de clases: ');
representantes = input('Ingrese el numero de representantes por clases: ');
coordsEsparcimiento = zeros(1,4,clases);
for i = 1:clases
    coordsEsparcimiento(1,1,i) = input('Ingrese las coordenadas de X: ');
    coordsEsparcimiento(1,2,i) = input('Ingrese las coordenadas de Y: ');
    coordsEsparcimiento(1,3,i) = input('Ingrese el esparcimiento de X: ');
    coordsEsparcimiento(1,4,i) = input('Ingrese el esparcimiento de Y: ');
end

coordenadas = zeros(2,representantes,clases);

for i =1:clases
    coordenadas(1,:,i) = (randn(1,representantes)+coordsEsparcimiento(1,1,i))*coordsEsparcimiento(1,3,i);
    coordenadas(2,:,i) = (randn(1,representantes)+coordsEsparcimiento(1,2,i))*coordsEsparcimiento(1,4,i);
end


%Se consigue la media de cada clase y se meten a una matriz
medias = zeros(2,1,clases);
for i = 1:clases
    medias(:,:,i) = mean(coordenadas(:,:,i),2);
end

coloresM = ['ro'; 'go'; 'co'; 'mo'; 'bo'; 'yo'; 'wo'];
colores = ['r'; 'g'; 'c'; 'm'; 'b'; 'y'; 'w'];

loop = 1;
while loop
    punto = zeros(1,2);
    punto(1,1) = input('Ingresa la coordenada en Y del punto desconocido: ');
    punto(1,2) = input('Ingresa la coordenada en Y del punto desconocido: ');
    
    figure(1)
    %dato=imref2d(size(h));
    %imshow(h,dato)
    %Se plotean los puntos
    grid on
    hold on
    for i = 1: clases
        plot(coordenadas(1,:,i),coordenadas(2,:,i),coloresM(i,:),'MarkerSize',10,'MarkerFaceColor',colores(i,:));
        leyendas{i} = sprintf('Clase %d', i);
    end
    plot(punto(1,1),punto(1,2),'ko','MarkerSize',10,'MarkerFaceColor','k')
    leyendas{i+1} = sprintf('Desconocido');
    legend(leyendas);
    
    %Se calculan las distancias
    dist_total = zeros(1,clases);
    for i = 1:clases
        dist_total(1,i) = norm(punto-medias(:,:,i));
    end


    %%%%%

    minimo=min(min(dist_total));
    dato=find(dist_total==minimo);
    fprintf('el vector desconocido pertenece a la clase %d\n',dato)
    opc = input('Desea probar con otro punto desconocido 1/0? ');
    if opc == 0
        loop = 0;
    end
    close
end


 disp(' fin de proceso..')
