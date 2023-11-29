clc %limpia pantalla
clear  % limpia todo 
warning off all 

% Lectura de la imagen de entrada
imagen_original = imread('pears.png');

% Conversión a escala de grises
imagen_gris = im2gray(imagen_original);

% Tamaño de la matriz imagen_gris
[filas, columnas] = size(imagen_gris);

% Tamaño del bloque para la DCT
tam_bloque = 8;

% Restamos 128 a toda la matriz
im_rest = imagen_gris - 128;

% Aplicamos la dct
%im_dct = dct2(im_rest);

% Creamos nuestra matriz cuantificadora
cuantificador = [16 11 10 16 24 40 51 61;
                12 12 14 19 26 58 60 55;
                14 13 16 24 40 57 69 56;
                14 17 22 29 51 87 80 62;
                18 22 37 56 68 109 103 77;
                24 35 55 64 81 104 113 92;
                49 64 78 87 103 121 120 101;
                72 92 95 98 112 100 103 99];

% Cálculo del número de bloques de 8x8 en cada dirección
num_bloques_filas = floor(filas / tam_bloque);
num_bloques_columnas = floor(columnas / tam_bloque);

% Creación de la tabla de categorías
dc_table = table([0;1;2;3;4;5;6;7;8;9;10;11;12;13;14], ...
    {'010'; '011'; '100'; '00'; '101';'110';'1110';'11110';'111110';'1111110';'11111110';'111111110';'1111111110';'11111111110';'111111111110'}, ...
    [3; 4; 5; 5; 7; 8; 10; 12; 14; 16; 18; 20; 22; 24; 26],'VariableNames',{'Category', 'Base Code', 'Length'});
category = [1;2;3;4;5;6;7;8;9;10;1;2;3;4;5;6;7;8;9;10;1;2;3;4;5;6;7;8;9;10;1;2;3;4;5;6;7;8;9;10;1;2;3;4;5;6;7;8;9;10];
ac_table = table([0; 0; 0; 0; 0; 0; 0; 0; 0; 0; ...
    1; 1; 1; 1; 1; 1; 1; 1; 1; 1; ...
    2; 2; 2; 2; 2; 2; 2; 2; 2; 2; ...
    3; 3; 3; 3; 3; 3; 3; 3; 3; 3; ...
    4; 4; 4; 4; 4; 4; 4; 4; 4; 4;], ...
    category, {'00';'01';'100';'1011';'11010';'111000';'1111000';'1111110110';'1111111110000010';'1111111110000011'; ...
    '1100';'111001';'1111001';'111110110';'11111110110';'1111111110000100';'1111111110000101';'1111111110000110';'1111111110000111';'1111111110001000'; ...
    '11011';'11111000';'1111110111';'1111111110001001';'1111111110001010';'1111111110001011';'1111111110001100';'1111111110001101';'1111111110001110';'1111111110001111'; ...
    '111010';'111110111';'11111110111';'1111111110010000';'1111111110010001'; '1111111110010010';'1111111110010011';'1111111110010100';'1111111110010101';'1111111110010110'; ...
    '111011';'1111111000';'1111111110010111';'1111111110011000';'1111111110011001';'1111111110011010';'1111111110011011';'1111111110011100';'1111111110011101'; '1111111110011110'},...
    [3;4;6;8;10;12;14;18;25;26;5;8;10;13;16;22;23;24;25;26;6;10;13;20;21;22;23;24;25;26;7;11;14;20;21;22;23;24;25;26;7;12;19;20;21;22;23;24;25;26],'VariableNames',{'Run', 'Category','Base Code','Length'});

% Recorremos la matriz en bloque de 8x8
bloques = zeros(8, 8 * num_bloques_columnas * num_bloques_filas);
k = 1;
for i = 1:num_bloques_filas
    for j = 1:num_bloques_columnas
        % Obtenemos un bloque

        bloque1 = im_rest((i-1)*tam_bloque+1:i*tam_bloque, (j-1)*tam_bloque+1:j*tam_bloque);
        % Aplicamos el cuantificador al bloque
        bloque1 = dct2(bloque1);
        im_rest((i-1)*tam_bloque+1:i*tam_bloque, (j-1)*tam_bloque+1:j*tam_bloque) = round(bloque1 ./ cuantificador);
        
        % Guardamos el bloque en el arreglo de bloques
        bloques(1:8, (k-1)*tam_bloque+1:k*tam_bloque) =  im_rest((i-1)*tam_bloque+1:i*tam_bloque, (j-1)*tam_bloque+1:j*tam_bloque);
        k = k+1;
    end
end

% Le pedimos un bloque al usuario
numbloques = num_bloques_columnas*num_bloques_filas;
disp('Bloques existentes: ')
disp(numbloques)
%disp('.....La longitud de su nombre es 11, se mostrará la codificación del bloque 11')
j=input('Ingrese el numero de bloque a codificar ');

% Obtenemos el bloque deseado
bloque = bloques(:, (j-1)*tam_bloque+1:j*tam_bloque);
subplot(1,2,1)
imshow(imagen_gris)
subplot(1,2,2)
imshow(bloque)
disp(bloque)

% Recorremos el bloque de manera diagonal para aplicar la compresión
n = size(bloque, 1);
m = size(bloque, 2);
diagonal = recorridoDiagonal2(bloque,tam_bloque,tam_bloque);
encontrarFinal(diagonal)



% disp(diagonal);

% Si tiene un bloque anterior para cada pixel calculamos length
% Cálculo del pixel anterior
pixel_anterior = 0;
if j > 1
    % Sobre la primera fila
    pixel_anterior = bloques(1, (j-2)*tam_bloque+1);
end
% Restamos el primer pixel del bloque actual menos el del anterior
resta = diagonal(1,1) - pixel_anterior;

% Vemos en qué rango se encuentra la resta
dc_difference_category = 0;
dc_difference_category = obtenerCategoria(dc_difference_category,diagonal(1,1));


% Obtenemos su length y su base Code
ind = 1;
    for tam = 1:15
        dcdc = dc_table{tam,"Category"};
        if  dcdc == dc_difference_category
            break;
        else 
            ind = ind + 1;
        end
    end
lengthDC = dc_table{ind, "Length"};
baseCode = dc_table{ind, "Base Code"};

diagonal_binarios = cell(1,0);
diagonal_binarios= cellfun(@(x) x, diagonal_binarios, 'UniformOutput', false);
% Si es negativo, entonces aplicamos complemento a 2
if resta < 0
    % Convertir resta a binario de 8 bits
    binDC = dec2bin(abs(resta));  
    
    % Aplicar complemento a 2
    binDC = num2str(~(binDC-'0'));
    binDC = strcat('1', binDC);
    complemento = bin2dec(binDC) + 1; 
    
    dc_pixel = strcat(baseCode, string(dec2bin(complemento)));
  
    diagonal_binarios{end+1} = dc_pixel;
     % Actualizamos el pixel en la im_dct
else
    % Si la resta es positiva, únicamente convertimos a binario
    binDC = dec2bin(resta);
    
    % Concatenamos el binario con el basecode
    dc_pixel = strcat(baseCode,string(binDC));
    diagonal_binarios{end+1} = dc_pixel;

end

% Para las frecuencias AC

% Checamos en que Run/Category se encuentra cada pixel
run = 0;
for pixel = 2: 63
    valor = diagonal(1,pixel);
    if valor == 0
        run = run + 1;
    else 
        % Ya tenemos cuántos ceros hay desde el valor anterior 
        
        % Ahora buscamos la categoría
        ac_category = 0;
        ac_category = obtenerCategoria(ac_category,valor);

        % Obtenemos Base Code y Length del pixel
        indice = 1;
        for tam = 1:50
            acc=ac_table{tam,"Category"};
            if acc == ac_category
                break;
            else 
                indice = indice + 1;
            end
        end
        ac_base_code = ac_table{indice,"Base Code"};
        ac_length = ac_table{indice,"Length"};

        % Si es negativo, entonces aplicamos complemento a 2
        if resta < 0
             % Convertir resta a binario de 8 bits
            bin = dec2bin(abs(resta));  
            
            % Aplicar complemento a 2
            bin = num2str(~(bin-'0'));
            bin = strcat('1', bin);
            complemento = bin2dec(string(bin)) + 1; 
            
            dc_pixel = strcat(baseCode, string(dec2bin(complemento)));
          
            diagonal_binarios{end+1} = dc_pixel;
        else
            % Si la resta es positiva, únicamente convertimos a binario
            bin = dec2bin(valor);
            
            % Concatenamos el binario con el basecode
            dc_pixel = strcat(baseCode,string(bin));
            diagonal_binarios{end+1} = dc_pixel;
        end
    end
end
diagonal_ac = diagonal(2:64);
diagonal_ac = nonzeros(diagonal_ac);
diagonal_ac = [diagonal_ac;0];
diag_concatenada = [diagonal(1,1);diagonal_ac];
diagonal_binarios{end+1} = "1010";
diagonal_binarios = diagonal_binarios';

tablita = table(diag_concatenada, diagonal_binarios,'VariableNames',{'Pixel','Pixel Codificado'});
disp(tablita);

function diagonal = recorridoDiagonal(matriz, col, row)
    diagonal = zeros(1,64);
    diagonal(1) = matriz(1,1);
    k=2;
    i=1;
    j=1;
    while k < (64)
        while i>=2 && j<row
            i=i - 1;
            j=j+1;
            diagonal(k) = matriz(i,j);
            k=1 + k;
        end
        if j<row
            j=1+j;
            diagonal(k) = matriz(i,j);
            k=1+k;
        elseif i<col
            i=1+i;
            diagonal(k) = matriz(i,j);
            k=1+k;
        end
        while i<col && j>=2
            i=1+i;
            j=j-1;
            diagonal(k) = matriz(i,j);
            k=1+k;
        end
        if i<col
            i=1+i;
            diagonal(k) = matriz(i,j);
            k=1+k;
        elseif j<row
            j=1+j;
            diagonal(k) = matriz(i,j);
            k=1+k;
        end
    end
end

function dc_difference_category = obtenerCategoria(dc_difference_category, resta)
    if resta == 0 
        dc_difference_category = 0;
    elseif resta == -1 || resta == 1
        dc_difference_category = 1;
    elseif (resta >= -3 && resta <= -2) || (resta >= 2 && resta <= 3)
        dc_difference_category = 2;
    elseif (resta >= -7 && resta <= -4) || (resta >= 4 && resta <= 7)
        dc_difference_category = 3;
    elseif (resta >= -15 && resta <= -8) || (resta >= 8 && resta <= 15)
        dc_difference_category = 4;
    elseif (resta >= -31 && resta <= -16) || (resta >= 16 && resta <= 31)
        dc_difference_category = 5;
    elseif (resta >= -63 && resta <= -32) || (resta >= 32 && resta <= 63)
        dc_difference_category = 6;
    elseif (resta >= -127 && resta <= -64) || (resta >= 64 && resta <= 127)
        dc_difference_category = 7;
    elseif (resta >= -255 && resta <= -128) || (resta >= 128 && resta <= 255)
        dc_difference_category = 8;
    elseif (resta >= -511 && resta <= -256) || (resta >= 256 && resta <= 511)
        dc_difference_category = 9;
    elseif  (resta >= -1023 && resta <= -512) || (resta >= 512 && resta <= 1023)
        dc_difference_category = 10;
    elseif  (resta >= -2047 && resta <= -1024) || (resta >= 1024 && resta <= 2047)
        dc_difference_category = 11;
    elseif (resta >= -4095 && resta <= -2048) || (resta >= 2048 && resta <= 4095)
        dc_difference_category = 12;
    elseif (resta >= -8191 && resta <= -4096) || (resta >= 4096 && resta <= 8191)
        dc_difference_category = 13;
    elseif (resta >= -16383 && resta <= -8192) || (resta >= 8192 && resta <= 16383)
        dc_difference_category = 14;
    end
end
function result = zigzag_traversal_print_end(block)
    [rows, cols] = size(block);
    result = zeros(1, rows * cols);
    
    row = 1;
    col = 1;
    index = 1;
    
    going_up = true;
    
    while row <= rows && col <= cols
        result(index) = block(row, col);
        index = index + 1;
        
        if row == rows && col == cols
            break;
        end
        
        if going_up
            if row == 1 || col == cols
                going_up = false;
                if col == cols
                    row = row + 1;
                else
                    col = col + 1;
                end
            elseif row == rows || col == 1
                going_up = false;
                if row == rows
                    col = col + 1;
                else
                    row = row + 1;
                end
            else
                row = row - 1;
                col = col + 1;
            end
        else
            if row == rows || col == 1
                going_up = true;
                if row == rows
                    col = col + 1;
                else
                    row = row + 1;
                end
            elseif row == 1 || col == cols
                going_up = true;
                if col == cols
                    row = row + 1;
                else
                    col = col + 1;
                end
            else
                row = row + 1;
                col = col - 1;
            end
        end
    end
    
    % Verificar si hay una secuencia de ceros al final
    zero_sequence = true;
    for i = index : rows * cols
        if result(i) ~= 0
            zero_sequence = false;
            break;
        end
    end
    
    % Imprimir mensaje si hay una secuencia de ceros al final
    if zero_sequence
        disp('Se encontró una secuencia de ceros consecutivos. Fin del recorrido.');
    end
end

function diagonal = recorridoDiagonal2(matriz, col, row)
    diagonal = zeros(1,64);
    diagonal(1) = matriz(1,1);
    k=2;
    i=1;
    j=1;
    fprintf('%d ', diagonal(1)); % Imprimir el primer elemento
    
    while k < (64)
        while i>=2 && j<row
            i=i - 1;
            j=j+1;
            diagonal(k) = matriz(i,j);
            fprintf('%d ', diagonal(k)); % Imprimir el número recorrido
            k=1 + k;
        end
        if j<row
            j=1+j;
            diagonal(k) = matriz(i,j);
            fprintf('%d ', diagonal(k)); % Imprimir el número recorrido
            k=1+k;
        elseif i<col
            i=1+i;
            diagonal(k) = matriz(i,j);
            fprintf('%d ', diagonal(k)); % Imprimir el número recorrido
            k=1+k;
        end
        while i<col && j>=2
            i=1+i;
            j=j-1;
            diagonal(k) = matriz(i,j);
            fprintf('%d ', diagonal(k)); % Imprimir el número recorrido
            k=1+k;
        end
        if i<col
            i=1+i;
            diagonal(k) = matriz(i,j);
            fprintf('%d ', diagonal(k)); % Imprimir el número recorrido
            k=1+k;
        elseif j<row
            j=1+j;
            diagonal(k) = matriz(i,j);
            fprintf('%d ', diagonal(k)); % Imprimir el número recorrido
            k=1+k;
        end
    end
    fprintf('\n'); % Salto de línea al final
end

function final = encontrarFinal(array);
    for i = 1:64
        aux = zeros(1,64-(i-1));
        disp(array(1,i))
        if aux == array(1,i:64)
            final = i;
            disp('EOB')
            break
        end
    end
end
