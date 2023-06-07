
%Con esto entramos en una carpeta y visualizamos todos sus archivos (sacado
%de internet)

%https://www.lawebdelprogramador.com/foros/Matlab/1536716-Leer-todos-los-archivos-de-una-carpeta.html

path='/Users/nataliap.st./Desktop/IngBiomédica/Proyectos II/subjects ECG.2/'; % ruta
ext='.txt'; % extension

 
ar=ls(path); %para listar los contenidos 
 for j=1:size(ar,1)
   nombreArchivo=ar(j,:); % aqui voy a tener almacenado todos los nombres de archivos de la carpeta referida
   [~,~,ex]=fileparts(nombreArchivo); %[filepath,name,extention]
    %isdir(cn)

   if (and(~isdir(fullfile(path,nombreArchivo)),or(strcmpi(strtrim(ex),ext),isempty(ext)))) %Comparamos 
       listaArchivos=strsplit(nombreArchivo,'.txt');
       %disp(listaArchivos);
     
       
      archivo=[];
      
      %elemento=[];
      for i= 1:(numel(listaArchivos)-1)

            elemento=listaArchivos(i);%ordenamos de menor a mayor
            a=strrep(elemento, char(9), ''); %Esto es para q no se guarde con tabulacion
            b=strrep(a,char(10), '');%Esto es para q no se guarde con salto de linea
            %disp(elemento);
            archivo= [archivo; fullfile(path,b)];%fullfile(path,nombreArchivo)
            %disp(i);
            %disp(archivo(i));
      
      end

      archivoOrdenado = sort(archivo);
      stringArchivo = string(archivoOrdenado);
      maxpksR_array=[];
      heartbeats_array=[];

      for j= 1:numel(archivoOrdenado)
          %disp(j)
          %fprintf(stringArchivo(j));
          %fprintf(strcat(stringArchivo(j), '.txt'))
          [~,~,~,maxpksR, heartbeats]= BITalinoFileReader(strcat(stringArchivo(j), '.txt'));
          %disp(maxpksR);
         maxpksR_array(j,1)= maxpksR;
         heartbeats_array(j,1)=heartbeats;
      end
      %BITalinoFileReader(archivo)
      %
        

% Calcular la correlación

fprintf("\nAmplitude-Heartbeats correlation")
[R1,P1] = corrcoef(maxpksR_array,heartbeats_array);
%R=0.0354
%P=0.8114
%La correlación obtenida indica que no existe una relación significativa entre los datos de maxpksR_array y heartbeats_array. El valor de R1 = 0.0354 indica una correlación muy cercana a cero, lo cual implica que no hay una asociación lineal aparente entre las dos variables. Además, el valor de p-value (P1 = 0.8114) es mayor al nivel de significancia comúnmente utilizado de 0.05, lo que indica que no hay evidencia suficiente para rechazar la hipótesis nula de que no hay correlación entre las variables.
%En resumen, los resultados indican que no hay una relación significativa entre maxpksR_array y heartbeats_array.





altura = [1.61, 1.65, 1.68, 1.80, 1.74, 1.65, 1.65, 1.85, 1.70, 1.80, 1.79, 1.63, 1.82, 1.81, 1.82, 1.84, 1.63, 1.63, 1.63, 1.68, 1.70, 1.59, 1.68, 1.74, 1.72, 1.82, 1.83, 1.79, 1.83, 1.84, 1.76, 1.67, 1.59, 1.80, 1.63, 1.65, 1.72, 1.70, 1.59, 1.81, 1.59, 1.75, 1.76, 1.77, 1.60, 1.79, 1.67, 1.57, 1.74, 1.60, 1.64, 1.60, 1.78, 1.56, 1.55, 1.70, 1.70, 1.62, 1.73, 1.78, 1.55, 1.60, 1.56, 1.80, 1.84, 1.65, 1.75, 1.73, 1.90, 1.80, 1.63, 1.75, 1.82, 1.69, 1.78, 1.83, 1.60, 1.78, 1.65, 1.69, 1.75, 1.70, 1.67, 1.77, 1.80, 1.73, 1.83, 1.76, 1.75, 1.64, 1.72, 1.62, 1.73, 1.85, 1.64, 1.75, 1.82, 1.58, 1.97];
peso = [65, 100, 75, 92, 75, 60, 54, 83, 85, 70, 66, 53, 72, 75, 55, 78, 57, 56, 68, 58, 61, 58, 55, 67, 53, 75, 74, 96, 79, 79, 79, 57, 48, 85, 60, 60, 53, 58, 58, 77, 47, 93, 75, 60, 75, 65, 55, 49, 76, 57, 42, 56, 60, 54, 80, 65, 80, 58, 62, 66, 50, 62, 50, 81, 83, 78, 55, 60, 85, 75, 55, 63, 85, 55, 68, 94, 63, 100, 64, 74, 71, 65, 78, 79, 85, 68, 79, 73, 75, 66.3, 98, 78, 82, 68, 61, 80, 76, 53, 100];
edad = [18, 49, 18, 58, 48, 22, 39, 22, 22, 21, 19, 20, 21, 20, 20, 21, 23, 22, 22, 22, 22, 21, 21, 21, 21, 18, 19, 26, 24, 29, 22, 19, 21, 21, 21, 22, 22, 21, 22, 21, 19, 26, 26, 19, 19, 24, 22, 21, 23, 22, 20, 22, 23, 22, 22, 20, 22, 19, 20, 21, 57, 43, 22, 23, 20, 24, 21, 22, 21, 22, 21, 21, 21, 20, 21, 57, 64, 51, 59, 59, 33, 42, 40, 24, 22, 20, 20, 23, 52, 60, 23, 53, 56, 42, 42, 48, 56, 24, 45];
posiciones_eliminar = [45, 57, 73, 84];

altura(posiciones_eliminar) = [];
peso(posiciones_eliminar) = [];
edad(posiciones_eliminar) = [];

IMC=[];

for k = 48:numel(altura)
    IMC=[IMC; (peso(k)/(altura(i)^2))]
end;



%AQUI 

fprintf("\nAmplitude-IMC correlation")
[R2,P2] = corrcoef(maxpksR_array,IMC);
%R2=0.4056
%P2=0.0042


% figure
% p = polyfit(maxpksR_array,IMC(49:96),1)
% 
% p =
% 
%     4.0667   23.9999
% 
% x_regression = linspace(min(maxpksR_array), max(maxpksR_array), 100);
% y_regression = polyval(p, x_regression);
% plot(maxpksR_array, IMC(49:96), 'o', x_regression, y_regression);
% xlabel('X');
% ylabel('Y');
% title('Regresión lineal');
% legend('Puntos', 'Regresión lineal');
% 
%La correlación obtenida indica que existe una relación positiva moderada entre los datos de maxpksR_array y peso en el rango de las posiciones 49 a 96. El valor de R3 = 0.4056 indica que aproximadamente el 40.56% de la variabilidad en peso puede ser explicada por la variabilidad en maxpksR_array. Esto sugiere una relación significativa entre estas variables.
%El valor de p-value (P3 = 0.0042) indica que la probabilidad de obtener una correlación igual o mayor a 0.4056 por azar es muy baja (menor al nivel de significancia comúnmente utilizado de 0.05). 
% Por lo tanto, se considera que la correlación entre maxpksR_array y peso en ese rango de posiciones es estadísticamente significativa.



%fprintf("\nAmplitude-Heigth correlation")
%[R3,P3] = corrcoef(maxpksR_array,altura(49:99));

%R3 =0.2096
%P3=0.1528

% p = polyfit(maxpksR_array,altura(49:96),1)
% 
% p =
% 
%       0.0373    1.6729
% 
% x_regression = linspace(min(maxpksR_array), max(maxpksR_array), 100);
% y_regression = polyval(p, x_regression);
% plot(maxpksR_array, IMC(49:96), 'o', x_regression, y_regression);
% xlabel('X');
% ylabel('Y');
% title('Regresión lineal');
% legend('Puntos', 'Regresión lineal');
% La correlación obtenida indica que existe una relación positiva débil entre los datos de maxpksR_array y altura en el rango de las posiciones 49 a 96. El valor de R3 = 0.2096 indica que aproximadamente el 20.96% de la variabilidad en altura puede ser explicada por la variabilidad en maxpksR_array. Sin embargo, debido a que la correlación es débil y el valor de p-value (P3 = 0.1528) es mayor al nivel de significancia comúnmente utilizado de 0.05, no se considera que la correlación sea estadísticamente significativa.
%En resumen, los resultados sugieren que hay una relación positiva débil entre maxpksR_array y altura en el rango de posiciones 49 a 96, pero esta relación no es estadísticamente significativa.


   end
 end

    
