clc
clear all
close all
warning off all

h=imread('peppers.png');
[m,n]=size(h);

dato=imref2d(size(h));% imref2d cambia cood del plano a coord de imagen

%Se le pide al usuario ingresar el numero de clases y representantes
clases = input('Cuantas clases quiere? ');
representantes = input('Cuantos representantes por clase quiere? ');

%Aqui se le pide al usuario ingresar los rangos de coordenadas de cada eje
%para cada clase
coords = zeros(clases,4);
for i = 1:clases
    figure()
    fprintf('Seleccione las dos coordenadas de la clase %d\n', i)
    [xi2,yi2,P] = impixel(h);
    coords(i,1) = xi2(1,:);
    coords(i,2) = xi2(2,:);
    coords(i,3) = yi2(1,:);
    coords(i,4) = yi2(2,:)
    close;
end

%Creacion y almacenamiento de las coordenadas aleatorias
c = zeros(2,representantes,clases);
for i = 1:clases
    cx = randi([coords(i,1), coords(i,2)],1,representantes);
    cy = randi([coords(i,3), coords(i,4)],1,representantes);
    c(1,:,i) = cx;
    c(2,:,i) = cy;
end

%Se consigue la media de cada clase y se meten a una matriz
medias = zeros(2,1,clases);
for i = 1:clases
    medias(:,:,i) = mean(c(:,:,i),2);
end
%Se hacen estos vectores para que cada punto ploteado tenga un color
%diferente
coloresM = ['ro'; 'go'; 'co'; 'mo'; 'bo'; 'yo'; 'wo'];
colores = ['r'; 'g'; 'c'; 'm'; 'b'; 'y'; 'w'];
loop = 1;
while loop
    % seleccionando las clases presentes en la imagen
    figure()
    disp('Seleccione la coordenada del punto desconocido')
    [xi2,yi2,P] = impixel(h);
    px=xi2(1,:);
    py=yi2(1,:);
    h=imread('peppers.png');
    dato=imref2d(size(h));

    punto=[px;py];
    figure(2)
    imshow(h,dato)
    %Se plotean los puntos
    grid on
    hold on
    for i = 1: clases
        plot(c(1,:,i),c(2,:,i),coloresM(i,:),'MarkerSize',10,'MarkerFaceColor',colores(i,:));
        leyendas{i} = sprintf('Clase %d', i);
    end
    plot(punto(1,:),punto(2,:),'ko','MarkerSize',10,'MarkerFaceColor','k')
    leyendas{i+1} = sprintf('Desconocido');
    legend(leyendas);
    
    
    %Se calculan las distancias
    dist_total = zeros(1,clases);
    for i = 1:clases
        dist_total(1,i) = norm(punto-medias(:,:,i));
    end
    
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