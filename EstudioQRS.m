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
     
      archivo=[];
      
      for i= 1:(numel(listaArchivos)-1)

            elemento=listaArchivos(i);%ordenamos de menor a mayor
            a=strrep(elemento, char(9), ''); %Esto es para q no se guarde con tabulacion
            b=strrep(a,char(10), '');%Esto es para q no se guarde con salto de linea
            archivo= [archivo; fullfile(path,b)];%fullfile(path,nombreArchivo)
            
      end

       getNumericValue = @(str) str2double(regexp(str, '\d+', 'match'));

      numericValues = cellfun(getNumericValue, archivo, 'UniformOutput', false); % Obtener los números de los nombres de archivo
      numericValues(cellfun(@isempty, numericValues)) = {NaN}; % Convertir los valores no numéricos a NaN
      [~, sortIdx] = sort(cell2mat(numericValues));% Ordenar los números y obtener el índice de orden
        
      sortedC = archivo(sortIdx);% Ordenar el cell array utilizando el índice de orden
      archivoOrdenado=sortedC(1:length(sortedC),2)


      stringArchivo = string(archivoOrdenado);
      maxpksR_array=[];
      heartbeats_array=[];
      amplitud_array = [];

      for j= 1:numel(archivoOrdenado)
          %disp(j)
          %fprintf(stringArchivo(j));
          %fprintf(strcat(stringArchivo(j), '.txt'))
          [~,~,~,maxpksR,heartbeats, amplitud]= BITalinoFileReader(strcat(stringArchivo(j), '.txt'));
          %disp(maxpksR);

         maxpksR_array(j,1)= maxpksR;
         heartbeats_array(j,1)=heartbeats;
         amplitud_array(j,1)= amplitud;
         
      end
      
        

    % % Calcular la correlación
    % 
     fprintf("\nAmplitude-Heartbeats correlation")
     [R1,P1] = corrcoef(amplitud_array,heartbeats_array);
    % %R1 =0.3043 -> correlacion
    % %P1 =0.2565

%     [~, p, ~, ~] = ttest2(amplitud_array,heartbeats_array);
%     p = 7.9707e-86
%     
%     figure
%     p = polyfit(amplitud_array,heartbeats_array,1)
%     p =  4.8235   74.3492
%     x_regression = linspace(min(amplitud_array), max(amplitud_array), 100);
%     y_regression = polyval(p, x_regression);
%     plot(maxpksR_array, heartbeats_array, 'o', x_regression, y_regression);
%     xlabel('Amplitude');
%     ylabel('Heartbeats');
%     title('Lineal regression');


altura = [1.61, 1.65, 1.68, 1.80, 1.74, 1.65, 1.65, 1.85, 1.70, 1.80, 1.79, 1.63, 1.82, 1.81, 1.82, 1.84, 1.63, 1.63, 1.63, 1.68, 1.70, 1.59, 1.68, 1.74, 1.72, 1.82, 1.83, 1.79, 1.83, 1.84, 1.76, 1.67, 1.59, 1.80, 1.63, 1.65, 1.72, 1.70, 1.59, 1.81, 1.59, 1.75, 1.76, 1.77, 1.60, 1.79, 1.67, 1.57, 1.74, 1.60, 1.64, 1.60, 1.78, 1.56, 1.55, 1.70, 1.70, 1.62, 1.73, 1.78, 1.55, 1.60, 1.56, 1.80, 1.84, 1.65, 1.75, 1.73, 1.90, 1.80, 1.63, 1.75, 1.82, 1.69, 1.78, 1.83, 1.60, 1.78, 1.65, 1.69, 1.75, 1.70, 1.67, 1.77, 1.80, 1.73, 1.83, 1.76, 1.75, 1.64, 1.72, 1.62, 1.73, 1.85, 1.64, 1.75, 1.82, 1.58, 1.97];
peso = [65, 100, 75, 92, 75, 60, 54, 83, 85, 70, 66, 53, 72, 75, 55, 78, 57, 56, 68, 58, 61, 58, 55, 67, 53, 75, 74, 96, 79, 79, 79, 57, 48, 85, 60, 60, 53, 58, 58, 77, 47, 93, 75, 60, 75, 65, 55, 49, 76, 57, 42, 56, 60, 54, 80, 65, 80, 58, 62, 66, 50, 62, 50, 81, 83, 78, 55, 60, 85, 75, 55, 63, 85, 55, 68, 94, 63, 100, 64, 74, 71, 65, 78, 79, 85, 68, 79, 73, 75, 66.3, 98, 78, 82, 68, 61, 80, 76, 53, 100];
edad = [18, 49, 18, 58, 48, 22, 39, 22, 22, 21, 19, 20, 21, 20, 20, 21, 23, 22, 22, 22, 22, 21, 21, 21, 21, 18, 19, 26, 24, 29, 22, 19, 21, 21, 21, 22, 22, 21, 22, 21, 19, 26, 26, 19, 19, 24, 22, 21, 23, 22, 20, 22, 23, 22, 22, 20, 22, 19, 20, 21, 57, 43, 22, 23, 20, 24, 21, 22, 21, 22, 21, 21, 21, 20, 21, 57, 64, 51, 59, 59, 33, 42, 40, 24, 22, 20, 20, 23, 52, 60, 23, 53, 56, 42, 42, 48, 56, 24, 45];

 posiciones_eliminar = [1, 8:27, 33, 42, 45, 57, 73, 84];
% 
%  altura(posiciones_eliminar) = [];
%  peso(posiciones_eliminar) = [];
%  edad(posiciones_eliminar) = [];

women = [2, 3, 6, 7, 32, 34, 36, 37, 38 , 39, 41, 44, 47, 48, 50, 51, 52, 53, 54, 55, 56, 58, 61, 62, 63, 67, 71, 72, 74, 77, 79, 82, 90, 92, 95, 98 ];
men = [4, 5, 28, 29, 30, 31, 35, 40, 43, 46, 49, 59, 60, 64, 65, 66, 68, 69, 70, 75, 76, 78, 80, 81, 83, 85, 86, 87, 88, 89, 91, 93, 94, 96, 97, 99];

womeninFolder = [1,2,5,6,11,12,14,15,16,17,19,21,23,24,26:33,36,37,38,42,46,47,48,51,53,56,63,65,68,71];%Posicion en la carpeta de las q son mujeres
meninFolder = [3,4,7,8,9,10,13,18,20,22,25,34,35,39,40,41,43,44,45,49,50,52,54,55,57:62,64,66,67,69,70,72];

alturaWomen=[];
alturaWomen= altura(women);

alturaMen=[];
alturaMen= altura(men);

pesoWomen=[];
pesoWomen= peso(women);

pesoMen = [];
pesoMen = peso(men);

edadWomen =[];
edadWomen=edad(women);

edadMen=[];
edadMen= edad(men);


% IMC=[];
% 
% alturaAll= altura;
% alturaAll(posiciones_eliminar) = [];
% 
% for k1 = 1:(numel(alturaAll))
%     IMC=[IMC; (peso(k1)/(alturaAll(k1)^2))]
% end;
% 
% 
% IMCWomen=[];
% 
% for k2 = 1:(numel(alturaWomen))
%     IMCWomen=[IMCWomen; (pesoWomen(k2)/(alturaWomen(k2)^2))]
% end;
% 
% 
% 
% IMCMen=[];
% 
% for k3 = 1:(numel(alturaMen))
%     IMCMen=[IMCMen; (pesoMen(k3)/(alturaMen(k3)^2))]
% end;
% 


%AQUI 

pesoAll= peso;
pesoAll(posiciones_eliminar) = [];

fprintf("\nAmplitude-Weigth correlation")
[R2,P2] = corrcoef(amplitud_array,pesoAll);
%R2=0.0593
%P2=0.6210

%[~, p, ~, ~] = ttest2(amplitud_array,pesoAll)
%p =8.9795e-82


% figure
% p = polyfit(amplitud_array,pesoAll,1)
% 
% p =
% 
%     2.2674   68.4073
% 
% x_regression = linspace(min(amplitud_array), max(amplitud_array), 100);
% y_regression = polyval(p, x_regression);
% plot(amplitud_array, pesoAll, 'o', x_regression, y_regression);
% xlabel('Amplitude');
% ylabel('Weight');
% title('Lineal Regression');
% 

%there is a significant and meaningful relationship between the amplitud_array
% and pesoAll. The extremely small p-value supports the existence of a correlation between 
% the two variables.

amplitudRWomen= []; 
amplitudWomen = amplitud_array(womeninFolder);

pesoWomen= []; 
pesoWomen = peso(womeninFolder);

amplitudMen= []; 
amplitudMen = amplitud_array(meninFolder);

pesoMen= []; 
pesoMen = peso(meninFolder);



fprintf("\nAmplitude-IMC Women correlation")
[R3,P3] = corrcoef(amplitudWomen,pesoWomen);

%R3= -0.0721
%P3= 0.6759
%[~, p, ~, ~] = ttest2(amplitudWomen,pesoWomen) -> p= 4.0268e-40
%figure
% p = polyfit(amplitudWomen,pesoWomen,1) 
% 
% p =
% 
%      -2.7105   66.8703
% 
% x_regression = linspace(min(amplitudWomen), max(amplitudWomen), 100);
% y_regression = polyval(p, x_regression);
% plot(amplitudWomen, pesoWomen, 'o', x_regression, y_regression);
% xlabel('Amplitude');
% ylabel('Weight');
% title('Women Lineal Regression');


%Por lo tanto, podemos afirmar que hay una relación significativa entre la amplitud y el peso de la mujer, aunque la correlación es débil.
%   -Existe una correlación débil y negativa entre la amplitud y el peso de la mujer.
%   -La correlación es altamente significativa desde el punto de vista estadístico, con un valor de p muy pequeño.
%   -A medida que el peso de la mujer aumenta, la amplitud tiende a disminuir, y viceversa.

fprintf("\nAmplitude-IMC Men correlation")
[R4,P4] = corrcoef(amplitudMen,pesoMen);
%R4=0.1101
%P4=0.5225
%[~, p, ~, ~] = ttest2(amplitudMen, pesoMen) -> p= 1.7465e-44

%figure
% p = polyfit(amplitudMen, pesoMen,1)
% 
% p =
% 
%      3.7050   65.7692
% 
% x_regression = linspace(min(amplitudMen), max(amplitudMen), 100);
% y_regression = polyval(p, x_regression);
% plot(amplitudMen, pesoMen, 'o', x_regression, y_regression);
% xlabel('Amplitude');
% ylabel('Weight');
% title('Men Lineal Regression');

%Por lo tanto, podemos afirmar que hay una relación significativa entre la amplitud y el 
% peso de los hombres, aunque la correlación es débil.
%A medida que el peso de los hombres aumenta, la amplitud también tiende a aumentar, y viceversa.

   end
 end

    
