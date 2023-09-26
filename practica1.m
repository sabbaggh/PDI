clc %limpia pantalla
close all %cierra todo
warning off all %evita las advertencias molestas


%%%%%%
%leyendo primera imagen
a=imread("imagen3.jpg"); %imread lee la imagen
%figure(1)
%imshow(a) %imshow despliega en pantalla la imagen
%disp('fin de programa')


%figure(2)
grises = rgb2gray(a);  %rgb2gray pasa las imagenes a grises
%imshow(grises)
%pasar a blanco y negro
%figure(3)
b_negro = im2bw(a);
%imshow(b_negro)

subplot(2,3,1)
imshow(a)
title('Original')
subplot(2,3,2)
imshow(grises)
title('Grises')
subplot(2,3,3)
imshow(b_negro)
title('Blanco y negro')

roja = a;
subplot(2,3,4)
roja(:,:,1);
roja(:,:,2)=0;
roja(:,:,3)=0;
imshow(roja)
title('Roja')

verde = a;
subplot(2,3,5)
verde(:,:,1)=0;
verde(:,:,2);
verde(:,:,3)=0;
imshow(verde)
title('Verde')

azul = a;
subplot(2,3,6)
azul(:,:,1)=0;
azul(:,:,2)=0;
azul(:,:,3);
imshow(azul)
title('Azul')

figure(2)
arreglo=[a roja; verde azul];
imshow(arreglo)

roja2 = roja(:,1:end/3,:);
verder2 = verde(:,end/3:end-end/3,:);
azul2 = azul(:,end-end/3:end,:);

figure(3)
arreglonuevo=[roja2 verder2 azul2];
imshow(arreglonuevo)

roja3 = roja(1:end/3,:,:);
verder3 = verde(end/3:end-end/3,:,:);
azul3 = azul(end-end/3:end,:,:);
figure(4)
arreglonuevo2=[roja3; verder3; azul3];
imshow(arreglonuevo2)

roja4 = roja(:,1:end/3,:);
letra = a(:,end/3:end-end/3,:);
verder4 = verde(:,end-end/3:end,:);
%Se hace la parte de arriba y se activa solamente el canal azul
parteArriba = letra(1:end/5,:,:);
parteArriba(:,:,3);
parteArriba(:,:,1)=0;
parteArriba(:,:,2)=0;
%Obtenemos la parte de medio y luego esta la partimos en tres verticalmente
%la parte izquierda y derecha estaran solo en canal azul y la parte de
%enmedio sera en blanco y negro
parteMedio = letra(end/5:(end/5)*3,:,:);
parteIzqMedio = parteMedio(:,1:end/3,:);
parteIzqMedio(:,:,3);
parteIzqMedio(:,:,1)=0;
parteIzqMedio(:,:,2)=0;
parteDerMedio = parteMedio(:,(end/3)*2:end,:);
parteDerMedio(:,:,3);
parteDerMedio(:,:,1)=0;
parteDerMedio(:,:,2)=0;
parteMedMedio = parteMedio(:,end/3:(end/3)*2,:);
%Se pasa esta parte a blanco y negro
parteMedMedioBW = im2bw(parteMedMedio);
%Se le agregan otros 2 arrays iguales en otra dimension para que se pueda
%concatenar con las partes azules
parteMedMedio2 = parteMedMedioBW;
parteMedMedio2(:,:,2) = parteMedMedioBW;
parteMedMedio2(:,:,3) = parteMedMedioBW;
%Se pasa de logical a uint8
parteMedMedio2 = im2uint8(parteMedMedio2);
%Se juntan todas las partes de Medio que construimos
parteMedio = [parteIzqMedio parteMedMedio2 parteDerMedio];
%Se obtiene el tamano de las columnas de la parte de arriba y medio para ver que no
%existan inconsistencias entre las matrices y se pueden concatenar
sizeArriba = size(parteArriba);
colArr = sizeArriba(2);
sizeMedio = size(parteMedio);
colMedio = sizeMedio(2);
if colMedio > colArr
    diferencia =  colMedio - colArr;
    parteMedio = parteMedio(:,1:end-diferencia,:);
end

%Se obtiene una parte intermedia y se pasa al canal azul
parteIntermedia = letra((end/5)*3:(end/5)*4,:,:);
parteIntermedia(:,:,3);
parteIntermedia(:,:,1)=0;
parteIntermedia(:,:,2)=0;
%Obtenemos la parte de abajo y se algo parecido a lo que se hizo en la
%parte de medio
parteAbajo = letra((end/5)*4:end,:,:);
%Izquierda Abajo
parteIzqAbajo = parteAbajo(:,1:end/3,:);
parteIzqAbajo(:,:,3);
parteIzqAbajo(:,:,1)=0;
parteIzqAbajo(:,:,2)=0;
%Medio abajo
parteMedAbajo = parteAbajo(:,end/3:(end/3)*2,:);
parteMedAbajoBW = im2bw(parteMedAbajo);
parteMedAbajo2 = parteMedAbajoBW;
parteMedAbajo2(:,:,2) = parteMedAbajoBW;
parteMedAbajo2(:,:,3) = parteMedAbajoBW;
parteMedAbajo2 = im2uint8(parteMedAbajo2);
%Derecha Abajo
parteDerAbajo = parteAbajo(:,(end/3)*2:end,:);
parteDerAbajo(:,:,3);
parteDerAbajo(:,:,1)=0;
parteDerAbajo(:,:,2)=0;
parteAbajo = [parteIzqAbajo parteMedAbajo2 parteDerAbajo];
%Se hace una comprobacion como con la parte de medio
sizeAbajo = size(parteAbajo);
colAba = sizeAbajo(2);
if colAba > colArr
    diferencia =  colAba - colArr;
    parteAbajo = parteAbajo(:,1:end-diferencia,:);
end




%Se juntan todas las partes de la letra
letraA = [parteArriba; parteMedio;parteIntermedia;parteAbajo];
%se comprueba que las filas de la letra y las demas partes sean iguales,
%sino se quitan algunas filas de la letra
sizeLetra = size(letraA);
sizeRoja = size(roja4);
filLetra = sizeLetra(1);
filRoja = sizeRoja(1);
if filLetra > filRoja
    diferencia = filLetra - filRoja;
    letraA = letraA(1:end-diferencia,:,:);
end

figure(5)
arreglonuevo3=[roja4 letraA verder4];
imshow(arreglonuevo3)

ancho = 900;
alto = 600;
letraA2 = zeros(alto,ancho,3);
left = letraA2(:,1:end/3,:);
left(:,:,1) = 255;
mid = letraA2(:,end/3:(end/3)*2,:);
midTop = mid(1:end/5,:,:);
midTop(:,:,3) = 255;
midMid = mid(end/5:(end/5)*3,:,:);
leftMidMid = midMid(:,1:end/3,:);
leftMidMid(:,:,3) = 255;
midmidmid = midMid(:,end/3:(end/3)*2,:);
rightMidMid = midMid(:,(end/3)*2:end,:);
rightMidMid(:,:,3) = 255;
midMid = [leftMidMid midmidmid rightMidMid];
sizeMid = size(midMid);
colMid = sizeMid(2);
sizeTop = size(midTop);
colTop = sizeTop(2);
if colMid > colTop
    diferencia = colMid - colTop;
    midMid = midMid(:,1:end-diferencia,:);
end
intermedio = mid((end/5)*3:(end/5)*4,:,:);
intermedio(:,:,3) = 255;
midAbajo = mid((end/5)*4:end,:,:);
midAbajoIzq = midAbajo(:,1:end/3,:);
midAbajoIzq(:,:,3) = 255;
midAbajoMid = midAbajo(:,end/3:(end/3)*2,:);
midAbajoDer =  midAbajo(:,(end/3)*2:end,:);
midAbajoDer(:,:,3) = 255;
midAbajo = [midAbajoIzq midAbajoMid midAbajoDer];
sizeAbajo = size(midAbajo);
colAbajo = sizeAbajo(2);
if colAbajo > colTop
    diferencia = colAbajo - colTop;
    midAbajo = midAbajo(:,1:end-diferencia,:);
end
right = letraA2(:,(end/3)*2:end,:);
right(:,:,2) = 255;
A = [midTop; midMid;intermedio;midAbajo];
sizeright = size(right);
filright = sizeright(1);
sizeA = size(A);
filA = sizeA(1);
if filA > filright
    diferencia = filA - filright;
    A = A(1:end-diferencia,:,:);
end
letraA2 = [left A right];
figure()
imshow(letraA2)

