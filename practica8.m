clc
clear all
close all
warning off all

a = imread("peppers.png");
a = rgb2gray(a);
[alto,ancho] = size(a);
imagenDCT = a;
imagenDCT = dct2(imagenDCT);
numBloquesFil = floor(alto/8)
numBloquesCol = floor(ancho/8)
figure(1)
imshow(imagenDCT)
title('Imagen con transformada de coseno discreto')
tamBloque = 8;
bits = 4;
nomuestras = 2^bits;
matrizOriginal = zeros(numBloquesFil,numBloquesCol);

for i = 1:numBloquesFil
    for j =1:numBloquesCol
        bloque = imagenDCT((i-1)*tamBloque+1:(i)*tamBloque, (j-1)*tamBloque+1:(j)*tamBloque);
        matrizOriginal(i,j) = bloque(1,1);
    end
end

matrizPrediccion = zeros(numBloquesFil, numBloquesCol);
matrizPrediccion(1:end,1) = matrizOriginal(1:end,1);
matrizPrediccion(1,1:end) = matrizOriginal(1,1:end);
matrizPrediccion = prediccion(matrizPrediccion,numBloquesCol,numBloquesFil);

matRecuperada = calcMatrizRecuperada(matrizOriginal,matrizPrediccion,nomuestras);
[mat_error_cuant, mat_error_cuant_inv] = cuantificar_error(matrizOriginal,matrizPrediccion,nomuestras);

% Creación de la matriz de imagen recuperada y aplicamos la inversa
mat_imagen_rec = matrizPrediccion + mat_error_cuant_inv;
matFinal = zeros(alto,ancho);
for i = 1:numBloquesFil
    for j = 1:numBloquesCol
        matFinal((i-1)*tamBloque+1,(j-1)*tamBloque+1) = mat_imagen_rec(i,j);
    end
end

var = 7;
colMatO2 = var * numBloquesCol;

%%Segundo predictor
matrizOriginal2 = zeros(numBloquesFil,var * numBloquesCol);

for i = 1:numBloquesFil
    for j =1:numBloquesCol
        bloque = imagenDCT((i-1)*tamBloque+1:(i)*tamBloque, (j-1)*tamBloque+1:(j)*tamBloque);
        matrizOriginal2(i,(j-1)*var+1:j * var) = bloque(1,2:tamBloque);
    end
end

matrizPrediccion2 = zeros(numBloquesFil, var * numBloquesCol);
matrizPrediccion2(1:end,1) = matrizOriginal2(1:end,1);
matrizPrediccion2(1,1:end) = matrizOriginal2(1,1:end);
matrizPrediccion2 = prediccion(matrizPrediccion2,var * numBloquesCol,numBloquesFil);
matRecuperada2 = calcMatrizRecuperada(matrizOriginal2,matrizPrediccion2,nomuestras);
[mat_error_cuant, mat_error_cuant_inv] = cuantificar_error(matrizOriginal2,matrizPrediccion2,nomuestras);

% Creación de la matriz de imagen recuperada y aplicamos la inversa
mat_imagen_rec2 = matrizPrediccion2 + mat_error_cuant_inv;
for i = 1:numBloquesFil
    for j = 1:numBloquesCol
        matFinal((i-1)*tamBloque+1,(j-1)*tamBloque+2:j * tamBloque) = mat_imagen_rec2(i,(j-1)*var+1:j * var);
    end
end

%%Predictor 3
matrizOriginal3 = zeros(var * numBloquesFil, numBloquesCol);
for i = 1:numBloquesFil
    for j = 1:numBloquesCol
        bloque = imagenDCT((i-1)*tamBloque+1:i*tamBloque, (j-1)*tamBloque+1:j*tamBloque);
        matrizOriginal3((i-1)*var+1:i * var,j) = bloque(2:tamBloque,1);
    end
end

matrizPrediccion3 = zeros(var * numBloquesFil, numBloquesCol);
matrizPrediccion3(1:end,1) = matrizOriginal3(1:end,1);
matrizPrediccion3(1,1:end) = matrizOriginal3(1,1:end);
matrizPrediccion3 = prediccion(matrizPrediccion3,numBloquesCol,var * numBloquesFil);
matRecuperada3 = calcMatrizRecuperada(matrizOriginal3,matrizPrediccion3,nomuestras);
[mat_error_cuant, mat_error_cuant_inv] = cuantificar_error(matrizOriginal3,matrizPrediccion3,nomuestras);

% Creación de la matriz de imagen recuperada y aplicamos la inversa
mat_imagen_rec3 = matrizPrediccion3 + mat_error_cuant_inv;
for i = 1:numBloquesFil
    for j = 1:numBloquesCol
        matFinal((i-1)*tamBloque+2:i * tamBloque, (j-1)*tamBloque+1) = mat_imagen_rec3((i-1)*var+1:i * var,j);
    end
end

%%Predictor 4
matrizOriginal4 = zeros((tamBloque - 1) * numBloquesFil, (tamBloque - 1)* numBloquesCol);
for i = 1:numBloquesFil
    for j = 1:numBloquesCol
        bloque = imagenDCT((i-1)*tamBloque+1:i*tamBloque, (j-1)*tamBloque+1:j*tamBloque);
        matrizOriginal4((i-1)*var+1:i * var,(j-1)*var+1:j * var) = bloque(2:tamBloque,2:tamBloque);
    end
end

matrizPrediccion4 = zeros((tamBloque - 1) * numBloquesFil, (tamBloque - 1)* numBloquesCol);
matrizPrediccion4(1:end,1) = matrizOriginal4(1:end,1);
matrizPrediccion4(1,1:end) = matrizOriginal4(1,1:end);
matrizPrediccion4 = prediccion(matrizPrediccion4,(tamBloque - 1)* numBloquesCol,(tamBloque - 1) * numBloquesFil);
matRecuperada4 = calcMatrizRecuperada(matrizOriginal4,matrizPrediccion4,nomuestras);
[mat_error_cuant, mat_error_cuant_inv] = cuantificar_error(matrizOriginal4,matrizPrediccion4,nomuestras);

% Creación de la matriz de imagen recuperada y aplicamos la inversa
mat_imagen_rec4 = matrizPrediccion4 + mat_error_cuant_inv;
for i = 1:numBloquesFil
    for j = 1:numBloquesCol
        matFinal((i-1)*tamBloque+2:i * tamBloque, (j-1)*tamBloque+2:j*tamBloque) = mat_imagen_rec4((i-1)*var+1:i * var,(j-1)*var+1:j*var);
    end
end
matFinal = idct2(matFinal);


figure(2)
subplot(2,2,1)
imshow(matrizOriginal)
subplot(2,2,2)
imshow(matrizOriginal2)
subplot(2,2,3)
imshow(uint8(matFinal))



function matPrediccion = prediccion(matPrediccion,ancho,alto)
    for i = 2:2:alto
        for j=2:2:ancho
            if j+1 <=ancho && i+1<=alto
                b1 = double((double(matPrediccion(i-1,j-1))+double(matPrediccion(i,j-1))+double(matPrediccion(i+1,j-1))+double(matPrediccion(i-1,j))+double(matPrediccion(i-1,j+1)))/5);
                b2 = double((double(matPrediccion(i - 1, j)) + double(matPrediccion(i - 1, j + 1)) + b1 )/ 3);
                b3 = double((double(matPrediccion(i, j - 1)) + double(matPrediccion(i + 1, j - 1)) + b1 + b2) / 4);
                b4 = double((b1 + b2 + b3) / 3);
                matPrediccion(i+1,j) = int64(b3);
                matPrediccion(i+1,j+1) = int64(b4);
                matPrediccion(i,j) = int64(b1);
                matPrediccion(i,j+1) = int64(b2);
            end
            
        end
    end
end

function recuperada = calcMatrizRecuperada(original,imPred,noMuestras)
    error = double(original)-double(imPred);
    [alto,ancho] = size(original);
    emax = max(max(error));
    emin = min(min(error));
    fi = (emax-emin)/noMuestras;
    abajo = zeros(1,noMuestras+1);
    sum = emin;
    for i = 1:noMuestras+1
        abajo(1,i) = sum;
        sum = sum+fi;
    end
    arriba = zeros(1,noMuestras);
    sum = 0;
    for i = 1:noMuestras
        arriba(1,i) = sum;
        sum = sum+1;
    end
    meq = zeros(alto,ancho,'double');
    for i =1:alto
        for j=1:ancho
            closest = interp1(abajo,abajo,error(i,j),'nearest');
            if closest == emin
                meq(i,j) = arriba(1);
            else
                indice = find(abajo == closest);
                if isempty(indice)
                    disp('Fuera de los intervalos')
                else
                    meq(i,j) = arriba(1,indice-1);
                end
            end
        end
    end
    meq1 = zeros(alto,ancho,'double');
    for i =1:alto
        for j=1:ancho
            target = meq(i,j);
            indice = find(arriba == target);
            meq1(i,j) = double((double(abajo(indice))+double(abajo(indice+1)))/2);
        end
    end
    recuperada = double(imPred) + double(meq1);
end

function [mat_error_cuant, mat_error_cuant_inv] = cuantificar_error(mat_O, mat_P, n_muestras)
% Creacion de la matriz de error
mat_error = mat_O - mat_P;

% Calculo de thetha
max_val = max(mat_error(:));
min_val = min(mat_error(:));
theta = (max_val - min_val) / n_muestras;

% Cuantificación del error
valores = min_val:theta:max_val;
limites_inferiores = valores(1) + (0:length(valores)-1)*theta - theta/2;
limites_inferiores(1) = valores(1);
limites_superiores = valores + theta/2;
intervalos = cat(2, limites_inferiores', limites_superiores');

mat_error_cuant = zeros(size(mat_error,1),size(mat_error,2));
mat_error_cuant_inv = zeros(size(mat_error,1),size(mat_error,2));
for i = 1:size(mat_error,1)
    for j = 1:size(mat_error,2)
        valor = mat_error(i,j);
        indice_intervalo = find(valor >= intervalos(:,1) & valor < intervalos(:,2), 1);
        if isempty(indice_intervalo)
            disp('El valor está fuera de todos los intervalos');
        end

        mat_error_cuant(i,j) = indice_intervalo;
        % Cuantificación inversa del error
        limite_inferior = intervalos(indice_intervalo, 1);
        limite_superior = intervalos(indice_intervalo, 2);
        
        promedio = (limite_superior + limite_inferior) / 2;
        mat_error_cuant_inv(i,j) = promedio;

    end
end
end


