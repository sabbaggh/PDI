% Limpia la ventana de comandos 
clc
% Borra todas las variables
clear all
% Cierra todas las figuras. 
close all
% Desactiva las advertencias.
warning off all

% Leer la imagen, convertirla a escala de grises y calcular su histograma para obtener las frecuencias de los píxeles.
a = imread("lalo2.jpg");
a = rgb2gray(a);
[frecuencias, pixeles] = imhist(a);

% Calcular la probabilidad de cada intensidad de píxel.
frecuencias = calcProbabilidad(frecuencias);

% Ordenar las frecuencias en orden descendente y eliminar las frecuencias cero.
frecSort = sort(frecuencias,'descend');
indices0 = ~ismember(frecSort,0);
frecSort = frecSort(indices0,1);
%frecSort = [0.2222; 0.1111; 0.1111; 0.1111; 0.1111; 0.1111; 0.1111; 0.1111];

% Inicializar matrices para las frecuencias normalizadas y los códigos de Huffman.
[filas,~] = size(frecSort);
frecuenciasN = zeros(filas, filas-1);
codigos = zeros(filas,filas-1);
codigos = string(codigos);
codigos(:,:) = "";
cont = 0;

% Construcción del árbol de Huffman y asignación de códigos binarios
while filas >2
    [filas,~] = size(frecSort);
    frecuenciasN(1:end-cont,cont+1) = frecSort; 
    frecN = double(frecSort(end-1,1)) + double(frecSort(end,1));
    frecSort = frecuenciasN(1:end-(cont+1),cont+1);
    frecSort(end,1) = frecN;
    frecSort = sort(frecSort,'descend');
    cont = cont+1;
end

% Asignar códigos binarios a cada frecuencia
[filas,~] = size(frecuenciasN);
for i = 1:filas-1
    % Lógica para la asignación de bits a los nodos del árbol de Huffman.
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
% Limpieza y preparación de la matriz final con frecuencias y códigos
%frecuencias sin ceros y como strings
frecuenciasN = limpiarMatriz(frecuenciasN);
%Matriz final donde se juntan las frecuencias y codigos de cada una, esto
%esta en strings
matFinal = crearMatrizFinal(frecuenciasN,codigos); % Agregar o quitar coment
% Guardar la matriz final en un archivo txt
writematrix(matFinal,'huffman.txt','Delimiter',';')
%creo que solo ocuparias las primeras columnas de cada matriz, la de codigo
%y frecuencias

%  ----------------------------------------Calculo de la entropia:
% Extraer la primera columna
primeraColumna = matFinal(:, 1);

% Inicializar un vector para almacenar los valores de entropía
entropias = zeros(length(primeraColumna), 1);

% Calcular la entropía para cada valor
for i = 1:length(primeraColumna)
    p = str2double(primeraColumna(i)); % Convertir el valor de cadena a número
    if p > 0
        entropias(i) = -p * log2(p); % Aplicar la fórmula de la entropía
    else
        entropias(i) = 0; % Si p es 0, su contribución a la entropía es 0
    end
end

% Sumar todas las entropías para obtener la entropía total
entropiaTotal = sum(entropias);
%imprimir en pantalla H
fprintf('entropia Total = %f\n', entropiaTotal);



% --------------------------------Calculo de la longitud Media:
% Extraer la primera columna (probabilidades) y la segunda columna (códigos Huffman)
probabilidades = matFinal(:, 1);
codigosHuffman = matFinal(:, 2);

% Inicializar en cero variable
LongitudMedia = 0;

% Calcular la longitud media
for i = 1:length(probabilidades)
    probabilidad = str2double(probabilidades(i)); % Convertir el valor de cadena a número
    longitudCodigo = length(codigosHuffman{i}); % Obtener la longitud del código Huffman

    % Multiplicar la probabilidad por la longitud del código y sumar al total
    LongitudMedia = LongitudMedia + (probabilidad * longitudCodigo);
end
%imprimir en pantalla Long. media
fprintf('Longitud Media = %f\n', LongitudMedia);

% Imprimir la eficiencia:
eficiencia = entropiaTotal/LongitudMedia;
fprintf('Eficiencia = %f\n', eficiencia);

% Función para calcular la probabilidad de cada frecuencia
function probabilidad = calcProbabilidad(frecuencias)
    tam = size(frecuencias);
    totalPixeles = sum(frecuencias);
    probabilidad = zeros(tam,"double");
    for i=1:tam
        probabilidad(i) = double(frecuencias(i))/totalPixeles;
    end
end

% Función para calcular el último índice útil en el arreglo durante la construcción del árbol de Huffman
function ultimoIndice = calcUltimoIndice(arr,i,filas,num)
    ultimoIndice = 0;
    for j = 1:filas
        if arr(j,end-(i-2)) >= num
            ultimoIndice = j;
        end
    end
end

% Función para crear la matriz final con frecuencias y códigos
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

% Función para limpiar la matriz de frecuencias, eliminando los ceros
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

