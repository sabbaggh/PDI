clc
clear all
close all
warning off all
clear variables

%cadena = string(input('Ingrese la cadena de bits: '));
cadena = '10110110110';
 a= imread("peppers.png");
 b = a(1:8,1:10);

longitud = strlength(cadena);

arrnuevo = calcNuevo(longitud,cadena);
[tablaVerdad,cantidad] = crearTabla(arrnuevo);
tablaIndices = buscarIndices(tablaVerdad);
arrnuevo(1,9) = 1;
errores = calcError(tablaIndices,arrnuevo);
bitError = encontrarBitError(tablaVerdad,errores,cantidad);
if bitError == 0
    fprintf('No se encontro ningun error\n')
else
    fprintf('El error esta en el bit %d\n',bitError)
end



function arrNuevo = calcNuevo(longitud, cadena)
    %tam = 0;
    for i = 0:Inf
        nuevoTam = 2^i;
        if nuevoTam >=longitud+i+1
            break
        end
        %tam = tam+1;
    end
    arrNuevo = zeros(1,nuevoTam);
    cont = 0;
    cont2 = 1;
    %[~,longitudCadena] = size(cadena);
    %tamtotal = longitudCadena+tam
    [~,col] = size(arrNuevo);
    for i = 1:col
        if 2^(cont) == i
            arrNuevo(1,i) = 0;
            cont = cont+1;
        else
            arrNuevo(1,i) = str2num(cadena(cont2));
            cont2 = cont2+1;
        end
    end
    arrNuevo = arrNuevo(:,1:end-1);

end

function [tabla, cont] = crearTabla(arr)
    [~,col] = size(arr);
    col = col+1;
    tam = Inf;
    cont = 0;
    while tam ~= 1
        tam = col/2;
        col = tam;
        cont = cont+1;
    end
    tabla = zeros(2^cont,cont);
    for i = 1: cont
        cont2 = 1;
        aumento = 2^(i-1);
        for j = 1:aumento:2^cont
            if mod(cont2,2) ~= 0
                cont2 = cont2+1;
            else
                tabla(j:j+(aumento-1),end-(i-1)) = ones(aumento,1);
                cont2 = cont2+1;
            end
        end
    end
end

function tablaIndices = buscarIndices(tablaVerdad)
    [fil,col] = size(tablaVerdad);
    tablaIndices = zeros(col,fil/2);
    for i=1:col
        indices = find(tablaVerdad(:,i)==1);
        tablaIndices(i,:) = indices';
    end
    tablaIndices = tablaIndices-1;
end

function error = calcError(tablaIndices,arr)
    [fil,col] = size(tablaIndices);
    error = zeros(1,fil);
    for i = 1:fil
        for j = 1:col-1
            if j == 1
                resultado = xor(arr(1,tablaIndices(i,j)),arr(1,tablaIndices(i,j+1)));
            else
                resultado = xor(resultado,arr(1,tablaIndices(i,j+1)));
            end
        end
        error(1,i) = resultado;
    end
end

function bitError = encontrarBitError(tablaVerdad,error,cantidad)
    [fil,col] = size(tablaVerdad);
    for i = 1:fil
        cont = 0;
        for j=1:col
            if tablaVerdad(i,j) == error(1,j)
                cont = cont+1;
            end
        end
        if cont == cantidad
            bitError = i;
            break
        end
    end
    bitError = bitError-1;
end