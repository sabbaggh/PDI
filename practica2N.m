clc
close all
clear all
warning off all

%mostrar imagen con imshow
a=imread('imagen1.jpg');

prompt1 = "Ingrese la cantidad de clases se van a usar: ";
prompt2 = "Ingrese la cantidad de representantes por clase: ";
numClases = input(prompt1);
numReps = input(prompt2);
clases3 = zeros(numReps,3,numClases);

h = image(a);
h.ButtonDownFcn = @clicky;
function clicky (gcbo,eventdata,handles)
    punto = (get(gca,'Currentpoint'))
    punto2 = punto(1,1:2)
end