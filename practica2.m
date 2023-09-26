clc
close all
clear all
warning off all

a=imread('peppers.png');
%Se le pregunta al usuario cuantas clases y representantes por clase va a
%usar
numClases = input("Ingrese la cantidad de clases se van a usar: ");
numReps = input("Ingrese la cantidad de representantes por clase: ");
%Se hace una matriz para almacenar los datos de cada representante en su
%respectiva clase, para esto se hace una matriz de 3 dimensiones 
clases3 = zeros(numReps,3,numClases);
figure(1)
%Se hace un ciclo for que se repetira el numero de clases
for i = 1:numClases
    fprintf('Ingrese los elementos de la clase %d...\n\n',i)
    clases = impixel(a);
    %Se agregan a la matriz de clases principal solamente el numero de
    %representantes que el usuario requirio al principio
    clases3(:,:,i) = clases(1:numReps,:);
end
close

%Esto es solo para imprimir las clases y ver que todo este bien
for x = 1:numClases
    fprintf('Clase %i: \n',x)
    disp(clases3(:,:,x))
end

%Se calcula la media de cada clase y se ingresan en otra matriz
%tridimensional pero que tiene solo una fila
medias = zeros(1,3,numClases);
for x = 1:numClases
    medias(:,:,x) = [mean(clases3(:,1,x)) mean(clases3(:,2,x)) mean(clases3(:,3,x))];
end

%En esta parte se crea un loop para que se sigan pidiendo mas valores
%desconocidos a menos que el usuario ingrese un cero
loop = 1;
while loop
    %Aqui el usuario ingresa el valor desconocido
    fprintf('Ingrese el elemento desconocido...\n\n')
    desc = impixel(a);
    elementoDes = desc(1,:);
    
    %Se calculan las distancias de cada media con respecto al elemento
    %desconocido y se ingresan en un array
    distancias = zeros(1,numClases);
    for x =1:numClases
        distancias(x) = norm(elementoDes-medias(:,:,x));
    end
    
    %Finalmente se saca el valor minimo y en que posicion se encontro este
    minimo = min(min(distancias));
    dato = find(distancias==minimo);
    close
    figure()
    view(3)
    hold on
    grid on
    fprintf('El valor desconocido pertenece a la clase %d\n', dato)
    coloresM = ['ro'; 'go'; 'co'; 'mo'; 'bo'; 'yo'; 'wo'];
    colores = ['r'; 'g'; 'c'; 'm'; 'b'; 'y'; 'w'];
    for i =1:numClases
        plot3(clases3(:,1,i),clases3(:,2,i),clases3(:,3,i),coloresM(i,:),'MarkerSize',10,'MarkerFaceColor',colores(i,:));
        leyendas{i} = sprintf('Clase %d', i);
    end
    plot3(elementoDes(:,1),elementoDes(:,2),elementoDes(:,3),'ko','MarkerSize',10,'MarkerFaceColor','k');
    leyendas{i+1} = sprintf('Desconocido');
    legend(leyendas);
    %Se le pregunta al usuario si quiere intentar con otro elemento
    %desconocido    
    continuar = input('Desea intentar con otro valor desconocido 1/0?');
    if continuar == 0
        loop = 0;
    end
    close
    
end

disp('fin del programa')
