clc
clear all
close all
warning off all

a = imread('winter4.jpg');
a = rgb2gray(a);
%a = [18 19 20;16 15 14; 18 20 21];
[alto, ancho] = size(a);


matA = a;
matA(2:alto,2:ancho) = 0;


imPred = prediccion(matA,ancho,alto);
%imPred = imPred(:,1:end-1);
error = zeros(alto,ancho,'double');
error = double(a)-double(imPred(:,:));
bits = 4;
emax = max(max(error));
emin = min(min(error));
noMuestras = 2^bits;
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
meq = zeros(alto,ancho);
for i =1:alto
    for j=1:ancho
        closest = interp1(abajo,abajo,error(i,j),'nearest');
        if closest == emin
            meq(i,j) = arriba(1);
        else
            indice = find(abajo == closest);
            meq(i,j) = arriba(indice-1);
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
recuperada = zeros(alto,ancho,'uint8');
for i =1:alto
    for j=1:ancho
        recuperada(i,j) = int64(double(meq1(i,j))+double(imPred(i,j)));
    end
end
figure()
subplot(1,3,1)
imshow(a)
title('Imagen Original')
subplot(1,3,2)
imshow(imPred)
title('Prediccion basada en las orillas de la imagen')
subplot(1,3,3)
imshow(recuperada)
title('Imagen Recuperada')

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














