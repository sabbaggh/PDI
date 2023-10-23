clc
clear all
close all
warning off all
a = imread('peppers.png');
a = rgb2gray(a);
[alto, ancho] = size(a);
conBordes = zeros(alto+2,ancho+2,"uint8");
ruidosa = imnoise(a,"salt & pepper",0.07);
conBordes(2:end-1,2:end-1) = ruidosa;



matrizRuido = detectPRuidoso(conBordes);
matrizRuido(:,1) = [];
nuevaImagenConCentral = quitarRuidoPorCentral(matrizRuido,conBordes);
nuevaImagenConModa = quitarRuidoPorModa(matrizRuido,conBordes);
nuevaConMaximo = elegirValorMaximo(matrizRuido,conBordes);
nuevaConMinimo = elegirValorMinimo(matrizRuido,conBordes);

subplot(2,3,1)
imshow(a)
title('Original')
subplot(2,3,2)
imshow(conBordes)
title('Ruido')
subplot(2,3,3)
imshow(nuevaImagenConCentral)
title('Por Central')
subplot(2,3,4)
imshow(nuevaImagenConModa)
title('Por Moda')
subplot(2,3,5)
imshow(nuevaConMaximo)
title('Sal')
subplot(2,3,6)
imshow(nuevaConMinimo)
title('Pimienta')

function porCentral = quitarRuidoPorCentral(matrizRuido,imagenR)
    [~, ancho] = size(matrizRuido);
    porCentral = imagenR;
    for i =1:ancho
        y = matrizRuido(1,i);
        x = matrizRuido(2,i);
        array = [imagenR(y,x),imagenR(y+1,x+1),imagenR(y-1,x-1),imagenR(y-1,x),imagenR(y-1,x+1),imagenR(y,x-1),imagenR(y+1,x-1),imagenR(y+1,x),imagenR(y,x+1)];
        valCentral = calcCentral(array);
        porCentral(y,x) = valCentral;
    end
end

function porModa = quitarRuidoPorModa(matrizRuido,imagenR)
    [~, ancho] = size(matrizRuido);
    porModa = imagenR;
    for i =1:ancho
        y = matrizRuido(1,i);
        x = matrizRuido(2,i);
        array = [imagenR(y,x),imagenR(y+1,x+1),imagenR(y-1,x-1),imagenR(y-1,x),imagenR(y-1,x+1),imagenR(y,x-1),imagenR(y+1,x-1),imagenR(y+1,x),imagenR(y,x+1)];
        moda = calcularModa(array);
        porModa(y,x) = moda;
    end
end

function porMaximo = elegirValorMaximo(matrizRuido,imagenR)
    [~, ancho] = size(matrizRuido);
    porMaximo = imagenR;
    for i =1:ancho
        y = matrizRuido(1,i);
        x = matrizRuido(2,i);
        array = [imagenR(y,x),imagenR(y+1,x+1),imagenR(y-1,x-1),imagenR(y-1,x),imagenR(y-1,x+1),imagenR(y,x-1),imagenR(y+1,x-1),imagenR(y+1,x),imagenR(y,x+1)];
        moda = calcMaximo(array);
        porMaximo(y,x) = moda;
    end
end

function porMinimo = elegirValorMinimo(matrizRuido,imagenR)
    [~, ancho] = size(matrizRuido);
    porMinimo = imagenR;
    for i =1:ancho
        y = matrizRuido(1,i);
        x = matrizRuido(2,i);
        array = [imagenR(y,x),imagenR(y+1,x+1),imagenR(y-1,x-1),imagenR(y-1,x),imagenR(y-1,x+1),imagenR(y,x-1),imagenR(y+1,x-1),imagenR(y+1,x),imagenR(y,x+1)];
        minimo = calcMinimo(array);
        porMinimo(y,x) = minimo;
    end
end


function porMedia = calcMedia(imagenR)
    [alto2, ancho2] = size(imagenR);
    porMedia = zeros(alto2,ancho2,"uint8");
    for i =2:alto2
        for j=2:ancho2
            porMedia(i,j)=round((double(imagenR(i,j))+double(imagenR(i+1,j+1))+double(imagenR(i-1,j-1))+double(imagenR(i-1,j))+double(imagenR(i-1,j+1))+double(imagenR(i,j-1))+double(imagenR(i+1,j-1))+double(imagenR(i+1,j))+double(imagenR(i,j+1)))/9);
        end
    end
end
function valorCentral = calcCentral(array)
    B = sort(array);
    valorCentral = B(5);
end

function matrizRuidosos = detectPRuidoso(imagenR)
    [alto,ancho] = size(imagenR);
    matrizRuidosos = zeros(2,1);
    for i =2:alto-1
        for j=2:ancho-1
            media=round((double(imagenR(i,j))+double(imagenR(i+1,j+1))+double(imagenR(i-1,j-1))+double(imagenR(i-1,j))+double(imagenR(i-1,j+1))+double(imagenR(i,j-1))+double(imagenR(i+1,j-1))+double(imagenR(i+1,j))+double(imagenR(i,j+1)))/9);
            if imagenR(i,j) > media+20 || imagenR(i,j) <media-20
                matrizRuidosos = [matrizRuidosos [i;j]];
            end
        end
    end
end

%function moda = calcularModa(array)
 %   [~,ancho] = size(array);
    % Inicializa un vector para guardar las frecuencias de cada valor de píxel
  %  frecuencias = zeros(1, ancho); % Haremos un vector de ceros de una fila y tantas columnas como el numero de pixeles de la imagen
    % Recorre la imagen y cuenta las ocurrencias de cada valor de píxel
   % for i = 1:ancho
    %    valor_pixel = array(i);
     %   frecuencias(valor_pixel) = frecuencias(valor_pixel) + 1;
   % end
    %disp(frecuencias)
    % Encuentra el valor de píxel con la mayor ocurrencia (moda)
    %maximo = calcMaximo(frecuencias)
    %[~, indice_moda] = max(frecuencias);
    %moda = indice_moda; % Restamos 1 para obtener el valor correcto

%end

function moda = calcularModa(arr)
    % Inicializa variables para realizar el seguimiento de la moda
    valoresUnicos = unique(arr); % Obtiene los valores únicos en el array
    [~,numValoresUnicos] = size(valoresUnicos);
    frecuencias = zeros(1, numValoresUnicos);
    
    % Calcula las frecuencias de cada valor
    for i = 1:numValoresUnicos
        frecuencias(i) = sum(arr == valoresUnicos(i));
    end
    
    % Encuentra el valor con la frecuencia máxima
    indice = calcMaximoInd(frecuencias);
    
    % La moda es el valor correspondiente a la frecuencia máxima
    moda = valoresUnicos(indice);
end

function maximo = calcMaximo(array)
    [~,ancho] = size(array);
    maximo = 0;
    for i =1:ancho
        if array(i) > maximo
            maximo = array(i);
        end
    end
end

function minimo = calcMinimo(array)
    [~,ancho] = size(array);
    minimo = 255;
    for i =1:ancho
        if array(i) < minimo
            minimo = array(i);
        end
    end
end

function maximoInd = calcMaximoInd(array)
    [~,ancho] = size(array);
    maximo = 0;
    maximoInd = 1;
    for i =1:ancho
        if array(i) > maximo
            maximoInd = i;
            maximo = array(i);
        end
    end
end