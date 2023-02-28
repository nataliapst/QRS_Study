%funcion guardamosAmplitudes = mandamosAmplitudes(amplitud);
%Con esto entramos en una carpeta y visualizamos todos sus archivos (sacado
%de internet)

%https://www.lawebdelprogramador.com/foros/Matlab/1536716-Leer-todos-los-archivos-de-una-carpeta.html

path='/Users/nataliap.st./Desktop/grabacionesEcg en txt/'; % ruta
ext='.txt'; % extension

 
ar=ls(path); %para listar los contenidos 
 for j=1:size(ar,1)
   nombreArchivo=ar(j,:); % aqui voy a tener almacenado todos los nombres de archivos de la carpeta referida
   [~,~,ex]=fileparts(nombreArchivo); %[filepath,name,extention]
    %isdir(cn)

   if (and(~isdir(fullfile(path,nombreArchivo)),or(strcmpi(strtrim(ex),ext),isempty(ext)))) %Comparamos 
       listaArchivos=strsplit(nombreArchivo, '\n') ;
     
       %amplitudes= importdata(listaArchivos);
       
       %for i=1:length(listaArchivos)
       %valoresAmplitudes= BITalinoFileReader(listaArchivos);
       %printf('%f\n',valoresAmplitudes);
       %end

      % disp(valoresAmplitudes);
       %guardamosAmplitudes = mandamosAmplitudes(amplitud);
       %%%% aca iria el programa principal
       %%%% fid = fopen(fullfile(path,nombreArchivo));
       %%%% etc
   end
 end

   disp(listaArchivos);
    
   for i=1:length(listaArchivos)
   file= strcat(path, listaArchivos, '/',' ');
   %amplitudes= BITalinoFileReader(file);

   end


%datosBitalino = BITalinoFileReader(nombreArchivo);