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
    bitCambiado = zeros(1,longitud);
    bitCambiado = string(bitCambiado);
    for i = 1:longitud
        if i == num
            if cadena(i) == "1"
                bitCambiado(i) = "0";
            else
                bitCambiado(i) = "1";
            end
        else
            bitCambiado(i) = cadena(i);
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









































































