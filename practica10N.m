clc
clear all
close all
warning off all
clear variables

cadena = num2str(input('Ingrese la cadena de bits: '));
num = input('\nIngrese el bit a cambiar: ');
nuevCadena = cmabiarBit(cadena, num);
disp(nuevCadena)
bitError = encontrarBitCambiado(cadena,nuevCadena);
fprintf('Se modifico el bit %d',bitError)


function bitCambiado = cmabiarBit(cadena,num)
    longitud = strlength(cadena);
    bitCambiado = '';
    cadena(1)
    for i = 1:longitud
        if i == num
            if cadena(i) == "1"
                bitCambiado = bitCambiado+"0";
            else
                bitCambiado = bitCambiado+"1";
            end
        else
            bitCambiado = bitCambiado + cadena(i);
        end

    end
end

function bitError = encontrarBitCambiado(cadenaOrg, cadenaNuev)
    longitud = strlength(cadenaOrg);
    for i =1:longitud
        if cadenaOrg(i) ~= cadenaNuev(i)
            bitError = i;
        end
    end
end