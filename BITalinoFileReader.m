function[data,t,header, heartbeats, amplitud_media_real] = BITalinoFileReader(file)

    %addpath('./jsonlab')
    %to convert matlab->java or java->matlab

    headerlines = 3;

    data=textread(file,'','headerlines',headerlines);

    realdata= data(1:length(data),7);
   
    ecgReal= ((realdata/(2^16))-0.5)*300; %con esto ajustamos la amplitud
    % 3300/1100 (es decir 3) 
    %multiplicamos por 300 ya que los electrodos obtienen el voltaje en
    %"crudo" y nosotros queremos milivoltios
 

    %ajustamos el tiempo  ->  samplingRate= 1000;
    t= (1/1000);
    vect = (1:1:length(ecgReal)); %(inicio:incremento:fin)
    tiempo = vect*t;

    %centramos en cero la señal
    %ecgFinal=(ecgReal-mean(ecgReal))/std(ecgReal);

   [p,s,mu] = polyfit((1:numel(ecgReal))',ecgReal,10);
    f_y = polyval(p,(1:numel(ecgReal))',[],mu);
    ECG_data = (ecgReal - f_y);
    

    %LOWPASS FILTER THAT REDUCES THE NOISE
    %lowpass Butterworth filter
    fNorm = 45 / (1000/2);
    [b,a] = butter(10, fNorm, 'low');
    y =filtfilt(b, a, ECG_data);
    %subplot(212), plot(t,y);
    %title('Filtered ECG Signal');
    ECG_data_update = y;
%https://es.mathworks.com/matlabcentral/answers/524664-identifying-qrs-point-in-ecg-signal



um_y = 6*mean(abs(ECG_data_update)); %De esta manera escogemos los picos que esten por encima de un umbral
um_x= 0.5*1000; %CORROBORAR SI ES 1100
% 
% pksR = zeros(1, length(ECG_data_update-20000));
% locs_Rwave= zeros(1, length(ECG_data_update-20000)); 
% widthR= zeros(1, length(ECG_data_update-20000)); 
% 

[pksR, locs_Rwave, widthR]= findpeaks(ECG_data_update(10000:(length(ECG_data_update)-10000)), 'MinPeakWidth',10,'MinPeakDistance',um_x,'MinPeakProminence',0.35);
%[pksR, locs_Rwave, ~] = findpeaks(ECG_data_update(10000:50000), 'MinPeakWidth',10,'MinPeakDistance',um_x,'MinPeakProminence',0.35);
%'MinPeakProminence',0.35 pq lo dijo sergio en el paper-> hay q buscar en que se basó, pero parece que ayuda.

%findpeaks(ECG_data(25000:35000), 'MinPeakWidth',30,'MinPeakDistance',um_x)
[pksS, locs_Swave, widthS]= findpeaks(-ECG_data_update(10000:(length(ECG_data_update)-10000)), 'MinPeakWidth',100,'MinPeakDistance',um_x,'MinPeakProminence',0.35);

% - - - - - - - - - - - - - - - - - - - - - 

[pksAll, locs_Allwaves] = findpeaks(ECG_data_update(10000:(length(ECG_data_update)-10000)));
%Aqui vamos a guardar todos los máximos que encuentra la señal invertida en el eje x

pksQ = [];
locs_Qwave = [];
widthQ=[];


for j = 2:numel(pksAll)
    for i = 1:numel(pksR)

        if (pksAll(j)==pksR(i))
    
            pksQ = [pksQ; (pksAll(j-1))];
            locs_Qwave = [locs_Qwave; (locs_Allwaves(j-1))];
   
        end
    end

end;

if length(pksQ)>length(locs_Qwave)
    pksQ(length(pksQ))=[];
end

if length(pksQ)<length(locs_Qwave)
    locs_Qwave(length(locs_Qwave))=[];  
end

for a = 1:numel(locs_Qwave)
    widthQ = [widthQ; (locs_Rwave(a)-locs_Qwave(a))];
end

%Aqui lo que hacemos es escoger el máximo que haya anterior al segmento R,
%de manera que realmente estamos guardando los picos Q.

amplitud=[];
minimos=[];
amplitud_media=0;
prev_r_wave = 0;

for b = 1:numel(pksAll)
    for i = 1:numel(pksR)
        if (locs_Rwave(i) - prev_r_wave >= 600) 
            if (pksAll(b)==pksR(i)) && (locs_Rwave(i) - prev_r_wave >= 600) 
        
               inicio= pksR(i) - 80;
               fin=pksR(i) +120;
    
               pksIntervalo = pksAll((locs_Allwaves >= inicio) & (locs_Allwaves <= fin));
               [minPico, ~] = min(pksIntervalo);
               minimos=[minimos;min(pksIntervalo) ]
    
               amplitud= [amplitud; (pksR(i)-minPico)];
               amplitud_media= amplitud_media + (pksR(i)-minPico);
    
            end
        end
        prev_r_wave = locs_Rwave(i);
    end

end;

amplitud_media_real = amplitud_media/length(amplitud);


% arrays = [length(pksQ), length(pksR), length(pksS)];
% tam = arrays(1);
% for b = 1:length(arrays)
%     if tam > arrays(b)
%         %print(b)
%         tam = arrays(b);
%        
%     end
% end
% 
% prev_r_wave = 0;  % Variable para almacenar el valor anterior de locs_Rwave
% amplitud=[];
% amplitud_media=0;
% cont=1; 
% 

%     for c = 1:tam   
%         if (cont<tam) && (locs_Swave(c) > (locs_Rwave(cont) + 150)) 
%             cont=cont+1;
%         end
%     
%         if (cont<tam) && (locs_Swave(c) <= (locs_Rwave(cont) + 150)) %&& (locs_Rwave(cont) - prev_r_wave >= 600) 
%             amplitud=[amplitud; (abs(pksR(cont)-pksS(c)))];
%             amplitud_media= amplitud_media + (abs(pksR(cont)-pksS(c)));
%        
%         end
%      
%         prev_r_wave = locs_Rwave(cont);
%         
%         if(cont==tam)
%             break;
%         else
%             cont=cont+1;
%         end 
%          
%     end
% 
% amplitud_media_real = amplitud_media/length(amplitud);





%heartbeats = latidos / min = duracion complejo QRS/ min

duracionECG = ((length(ECG_data_update)-20000)/1000);
heartbeats = (numel(pksR)*(60/duracionECG) );
%como estamos muestreando 10seg la señal,
% %si multiplicamos el numerador y el denominador por 6 tenemos los latidos
% por minuto.
%Un latido es un intervalo RR por eso (numel(pksR)-1), asi contamos intervalos y no número de picos R encontrados
%60-100bpm


    %seguimos con la funcion
    header = {};

     fid = fopen(file, 'r'); % esto significa abrir el archivo para leerlo (read)

     for i=1:headerlines %de 1 a 3
        header(i) = {fgets(fid)};
     end
     fclose(fid);
    
    header = jsondecode(strrep(header{2}(2:end),' ','')); 
    
    devices = fieldnames(header);
    srate = header.(devices{1}).samplingrate;
    
    
    if length(devices) == 1
        header = header.(devices{1});
    end
    
    dseq = diff(diff(data(:,1)));
    
    if ~isempty(setdiff(unique(diff(data(:,1))), [-15,1]))
        t =  [];
        warning('Possible sample loss detected');
    else
        t = (1:length(data))/srate;
    end
