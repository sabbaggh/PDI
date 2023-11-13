clc
clear all
close all
warning off all

a = imread("lalo2.jpg");
a = rgb2gray(a);
[frecuencias, pixeles] = imhist(a);
frecuencias = calcProbabilidad(frecuencias);
frecSort = sort(frecuencias,'descend');
indices0 = ~ismember(frecSort,0);
frecSort = frecSort(indices0,1);
%frecSort = [0.2222; 0.1111; 0.1111; 0.1111; 0.1111; 0.1111; 0.1111; 0.1111];
[filas,~] = size(frecSort);
frecuenciasN = zeros(filas, filas-1);
codigos = zeros(filas,filas-1);
codigos = string(codigos);
codigos(:,:) = "";
cont = 0;
while filas >2
    [filas,~] = size(frecSort);
    frecuenciasN(1:end-cont,cont+1) = frecSort; 
    frecN = double(frecSort(end-1,1)) + double(frecSort(end,1));
    frecSort = frecuenciasN(1:end-(cont+1),cont+1);
    frecSort(end,1) = frecN;
    frecSort = sort(frecSort,'descend');
    cont = cont+1;
end
[filas,~] = size(frecuenciasN);
for i = 1:filas-1
    if i == 1
        codigos(1,end-(i-1)) = codigos(1,end-(i-1))+"1";
        codigos(2,end-(i-1)) = codigos(2,end-(i-1))+"0";
    else
        num = frecuenciasN(i,end-(i-1))+frecuenciasN(i+1,end-(i-1));
        indice = calcUltimoIndice(frecuenciasN,i,filas,num);
        codigos(i,end-(i-1)) = codigos(indice,end-(i-2));
        codigos(i+1,end-(i-1)) = codigos(indice,end-(i-2));
        codigos(i,end-(i-1)) = codigos(i,end-(i-1)) + "1";
        codigos(i+1,end-(i-1)) = codigos(i+1,end-(i-1)) + "0";
        codigosSinIndice = ~ismember(codigos(:,end-(i-2)),codigos(indice,end-(i-2)));
        codigosSinIndice = codigosSinIndice(1:i);
        codigosN = codigos(codigosSinIndice,end-(i-2));
        codigos(1:i-1,end-(i-1)) = codigosN;
    end
   
end
%frecuencias sin ceros y como strings
frecuenciasN = limpiarMatriz(frecuenciasN);
%Matriz final donde se juntan las frecuencias y codigos de cada una, esto
%esta en strings
matFinal = crearMatrizFinal(frecuenciasN,codigos);
%Poner la matriz final en el txt
writematrix(matFinal,'huffman.txt','Delimiter',';')
%creo que solo ocuparias las primeras columnas de cada matriz, la de codigo
%y frecuencias



function probabilidad = calcProbabilidad(frecuencias)
    tam = size(frecuencias);
    totalPixeles = sum(frecuencias);
    probabilidad = zeros(tam,"double");
    for i=1:tam
        probabilidad(i) = double(frecuencias(i))/totalPixeles;
    end
end

function ultimoIndice = calcUltimoIndice(arr,i,filas,num)
    ultimoIndice = 0;
    for j = 1:filas
        if arr(j,end-(i-2)) >= num
            ultimoIndice = j;
        end
    end
end

function matFinal = crearMatrizFinal(frecuenciasN, codigos)
    [filas,~] = size(frecuenciasN);
    frecuenciasN = string(frecuenciasN);
    matiFinal = zeros(filas,filas*2-2);
    matFinal = string(matiFinal);
    matFinal(:,:) = "";
    contC = 1;
    contF = 1;
    for i = 1:filas*2-2
        if mod(i,2) == 0
            matFinal(:,i) = codigos(:,contC);
            contC = contC+1;
        else
            matFinal(:,i) = frecuenciasN(:,contF);
            contF = contF+1;
        end
    end
end

function matLimpia = limpiarMatriz(frecuenciasN)
    [filas,~] = size(frecuenciasN);
    frecuenciasN = string(frecuenciasN);
    matLimpia = zeros(size(frecuenciasN));
    matLimpia = string(matLimpia);
    matLimpia(:,:) = "";
    for i = 1:filas-1
        matLimpia(1:end-(i-1),i) = frecuenciasN(1:end-(i-1),i);
    end
end


