function[data,t,header] = BITalinoFileReader(file)
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
    %print(f_y)
    ECG_data = (ecgReal - f_y); % esto es z score o normal distribution???
    

    %LOWPASS FILTER THAT REDUCES THE NOISE
    %lowpass Butterworth filter
    fNorm = 45 / (1000/2);
    [b,a] = butter(10, fNorm, 'low');
    y =filtfilt(b, a, ECG_data);
    %subplot(212), plot(t,y);
    %title('Filtered ECG Signal');
    ECG_data_update = y;
%https://es.mathworks.com/matlabcentral/answers/524664-identifying-qrs-point-in-ecg-signal



um_y = 6*mean(abs(ECG_data));
um_x= 0.5*1000;


[pksR, locs_Rwave, widthR] = findpeaks(ECG_data_update(25000:35000), 'MinPeakWidth',10,'MinPeakDistance',um_x,'MinPeakProminence',0.35);
%'MinPeakProminence',0.35 pq lo dijo sergio en el paper-> hay q buscar en que se basó, pero parece que ayuda.

% maxPksR = max(pksR);
% maxPksQ = 0.25*maxPksR;

%findpeaks(ECG_data(25000:35000), 'MinPeakWidth',30,'MinPeakDistance',um_x)
[pksS, locs_Swave, widthS]= findpeaks(-ECG_data_update(25000:35000), 'MinPeakWidth',100,'MinPeakDistance',um_x,'MinPeakProminence',0.35);


%Esto fue un intento anterior de encontrar el segmento Q
%[pksQ, locs_Qwave]= findpeaks(-ECG_data_update(25000:35000),'MinPeakWidth',60,'MaxPeakWidth',120);
%findpeaks(-ECG_data_update(25000:35000),tiempo(25000:35000), 'MinPeakProminence',0.1);


% - - - - - - - - - - - - - - - - - - - - - 


[pksAll, locs_Allwaves] = findpeaks(-ECG_data_update(25000:35000));
%Aqui vamos a guardar todos los máximos que encuentra la señal invertida en el eje x


pksQ = [];
locs_Qwave = [];

[pksR_inv, locs_Rwave_inv] = findpeaks(-ECG_data_update(25000:35000), 'MinPeakWidth',10,'MinPeakDistance',um_x);
%Damos la vuelta en el eje x a la señal, para que se nos quede la Q y la S
%como máximos y los segmentos R como minimos. Y en esta función en específico localizamos las
%posiciones en las que se encuentra la R, en la señal invertida.



for j = 2:numel(pksAll)
    for i = 1:numel(pksR_inv)

        if (pksAll(j)==pksR_inv(i))
    
            pksQ = [pksQ; (pksAll(j-1))];
            locs_Qwave = [locs_Qwave; (locs_Allwaves(j-1))];
        
            %real_locsQ_wave = [real_locsQ_wave; locs_Qwave(a)];
        end
    end

end;
%Aqui lo que hacemos es escoger el máximo que haya anterior al segmento R,
%de manera que realmente estamos guardando los picos Q.




% Este era mi intento de conseguir el segmento Q, amos a decir, de manera
% más rigurosa, fijándome en información de distintos papers, como en la
% que el segmento Q tiene que durar aproximadamente entre
% 0.06-0.12segundos, que tiene que ser aprox el 0.25% de la señal R.
% También hay una función que cogi de internet que decia que la onda Q se
% encuentra entre -0.2mV and -0.5mV
 
            %     Buscamos los picos de Q que estarán entre -0.2mV and -0.5mV
            %     [pksQ,min_locs] = findpeaks(-ECG_data,'MinPeakDistance',40);
            %     locs_Qwave = min_locs(ECG_data(min_locs)>-0.5 & ECG_data(min_locs)<-0.2);
            %     %disp(pksQ)          

%Aunque la segunda función no sale


% cont=1;
% real_pksQ = [];
% real_locsQ_wave = [];
% 
% for a = 1:numel(pksQ)
%     if (pksQ(a) < maxPksQ)
%         real_pksQ = [real_pksQ; pksQ(a)];
%         real_locsQ_wave = [real_locsQ_wave; locs_Qwave(a)];
%     end
% end
% 
% 
% %maxSignal = [];
% realQvalue = [];
% value= 0;
% 
%     for i = 1:numel(locs_Rwave)-1 %1-16
%        % if i+1 <= numel(locs_Rwave) %17
%             lowerBound = (locs_Rwave(i)-120);
%             upperBound = locs_Rwave(i);
% 
%             for j = lowerBound:upperBound
%                 if j<=numel(real_pksQ) %21
%                     realQvalue= [realQvalue; real_pksQ(j)];
%                 end
% 
%             end
%       %  end
%     end




%                 if ((pksR>lowerBound) & (pksR < upperBound))
%                     realQvalue = max(pksQ(locs_Qwave >= real_locsQ_wave(i) & locs_Qwave < real_locsQ_wave(i+1)));
%                     maxSignal = [maxSignal; realQvalue];
%                     end
%Aqui hay algo que no esta bien



%amplitud = Onda R - Onda Q - Onda S
disp(max(pksR));
disp(max(pksQ));
disp(max(pksS));

amplitud = max(pksR) - max(pksQ) - max(pksS);

%heartbeats = latidos / min = duracion complejo QRS/ min

heartbeats= (numel(pksR)-1)*(6) ;%como estamos muestreando 10seg la señal,
% %si multiplicamos el numerador y el denominador por 6 tenemos los latidos
% por minuto.
%Un latido es un intervalo RR por eso (numel(pksR)-1), asi contamos intervalos y no número de picos R encontrados



                  
%TRYING TO DETECT THE Q WAVE
     %minPeak=-max(pksMin)% para que me coja el valor más negativo
     %maxPeak= max(pksR);
%picos maximos y minimos para calcular la media




%     amplitude = maxPeak - minPeak; %porque el mínimo será negativo
%     y = peak2peak(pksR)
    


% 
%     Buscamos los picos de Q que estarán entre -0.2mV and -0.5mV
%     [pksQ,min_locs] = findpeaks(-ECG_data,'MinPeakDistance',40);
%     locs_Qwave = min_locs(ECG_data(min_locs)>-0.5 & ECG_data(min_locs)<-0.2);
%     %disp(pksQ)
% 
% 



%
%     subplot(2,2,2);
%     plot(locs_Qwave,ECG_data(locs_Qwave),'rs','MarkerFaceColor','g');
%     grid on
%     title('Q wave')
%     xlabel('Samples')
%     ylabel('Voltage(mV)')
% 
%     subplot(2,2,3);
%     plot(locs_Rwave,ECG_data(locs_Rwave),'rv','MarkerFaceColor','r');
%     grid on
%     title('R wave')
%     xlabel('Samples')
%     ylabel('Voltage(mV)')
% 
%     subplot(2,2,4);
%     plot(locs_Swave,ECG_data(locs_Swave),'rs','MarkerFaceColor','b');
%     grid on
%     title('S wave')
%     xlabel('Samples')
%     ylabel('Voltage(mV)')
% 
%     %disp('Ondas R: ');
%     %fprintf('%f\n', pksR);
%     %disp('Amplitud max: ');
%     %fprintf('%f\n', maxPeak);
% 
%     minPeakS = min(ECG_data(locs_Swave))%-max(pksS); %como esta invertido coger el - (valor máximo) = valor minimo
%     minPeakQ = min(ECG_data(locs_Qwave));% para que los valores de Q se encuentren entre -0.2 y -0.5
% 
%     %disp('Ondas Q: ');
%     %fprintf('%f\n', ECG_data(locs_Qwave));
%     disp('Amplitud min Q: ');
%     fprintf('%f\n', minPeakQ);
%      disp('Amplitud min S: ');
%     fprintf('%f\n', minPeakS);
%     
%     if(minPeakS>minPeakQ)
%         minPeak = minPeakQ;
%     else
%         minPeak = minPeakS;
%    end
%     



%     disp('Amplitud total')
%     fprintf('%f\n', maxPeak)
%     disp('+')
%     fprintf('%f\n', minPeak)
%     disp('=')
%     fprintf('%f\n', amplitude) %-> parece que todo funciona bien

   
  
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

   

end
