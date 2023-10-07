clc
clear all
close all
warning off all

a =imread('imagen4.jpg');
a = rgb2gray(a);
b=imread('imagen5.jpg');
b = rgb2gray(b);
matEcu = ecu(a,1);
tam = size(a);
tamB = size(b);
xdd = zeros(tam,'uint8');
for i = 1:tam(1)
   for j = 1:tam(2)
        index = find(matEcu(1,:) == a(i,j));
        xdd(i,j) = matEcu(3,index);
   end
end

%Ecualizacion del histograma
figure(1)
subplot(2,2,1)
imshow(a)
title('Imagen original')
subplot(2,2,2)
imshow(xdd)
title('Imagen ecualizada')
subplot(2,2,3)
imhist(a)
title('Histograma original')
subplot(2,2,4)
imhist(xdd)
title('Histograma ecualizado')

%Histograma correspondencia
totalPixeles = tam(1)*tam(2);
frecuenciasA = frecuencias(matEcu(2,:),totalPixeles);
frecuenciasAcumA = frecuenciasAcum(frecuenciasA);
totalPixelesB = tamB(1)*tamB(2);
matEcuB = ecu(b,1);
frecuenciasB = frecuencias(matEcuB(2,:),totalPixeles);
frecuenciasAcumB = frecuenciasAcum(frecuenciasB);
xdd2 = zeros(tam,'uint8');
for i = 1:tam(1)
   for j = 1:tam(2)
        index = find(matEcu(1,:) == a(i,j));
        frecAbuscar = frecuenciasAcumA(index);
        differences = abs(frecuenciasAcumB - frecAbuscar);
        minDifferenceIndex = find(differences == min(differences));
        xdd2(i,j) = matEcuB(1,minDifferenceIndex);
   end
end

figure(2)
subplot(2,3,1)
imshow(a)
title('Imagen A')
subplot(2,3,2)
imshow(b)
title('Imagen B')
subplot(2,3,4)
imhist(a)
title('Histograma A')
subplot(2,3,5)
imhist(b)
title('Histograma B')
subplot(2,3,3)
imshow(xdd2)
title('Imagen A Correspondencia')
subplot(2,3,6)
imhist(xdd2)
title('Histograma A Correspondencia')

function arrFrecsAcum = frecuenciasAcum(arr)
    arrFrecsAcum = zeros(size(arr));
    for i = 1:length(arr)
        if i == 1
            arrFrecsAcum(i) = double(arr(i));
        else
            arrFrecsAcum(i) = double(arr(i)+arrFrecsAcum(i-1));
        end
    end
end

function arrfrecs = frecuencias(arr,totalPixeles)
    arrfrecs = zeros(size(arr));
    for i = 1:length(arr)
        arrfrecs(i) = double(arr(i)/totalPixeles);
    end 

end

function ecualizacion = ecu(imagen,color)
    unicos = sort(unique(reshape(imagen(:,:,color).',1,[])));
    matrizPlana = reshape(imagen(:,:,color).',1,[]);
    tam = size(unicos);
    totalPixeles = length(matrizPlana);
    matEcualizacion = zeros(3,tam(2));
    matEcualizacion(1,:) = unicos;
    recuentosUnicos = zeros(size(unicos));
    minI = double(min(min(imagen(:,:,color))));
    maxI = double(max(max(imagen(:,:,color))));
    % Itera a través de los valores únicos y cuenta sus ocurrencias en A
    for i = 1:length(unicos)
        recuentosUnicos(i) = sum(matrizPlana == unicos(i));
    end 
    matEcualizacion(2,:) = recuentosUnicos;
    %frecuencias
    arrfrecuencias = frecuencias(matEcualizacion(2,:),totalPixeles);
    %frecuencias acumuladas
    arrfrecAcum = frecuenciasAcum(arrfrecuencias);
    %FG
    fg = zeros(size(unicos));
    for i = 1:length(unicos)
        fg(i) = round(((maxI-minI)*arrfrecAcum(i))+minI); 
    end
    matEcualizacion(3,:) = fg;
    ecualizacion = matEcualizacion;
end

