clc
clear all
close all
warning off all
clear variables

%cadena = string(input('Ingrese la cadena de bits: '));
cadena = "10110110110";


longitud = strlength(cadena);

arrnuevo = calcNuevo(longitud)

function arrNuevo = calcNuevo(longitud)
    for i = 0:Inf
        nuevoTam = 2^i;
        if nuevoTam >=longitud+i+1
            break
        end
    end
    arrNuevo = zeros(1,nuevoTam);
    

end