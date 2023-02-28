function[data,t,header] = BITalinoFileReader(file2)
 
    %addpath('./jsonlab'= )
    %to convert matlab->java or java->matlab

    headerlines = 3;

    data= textread(file2,'','headerlines',headerlines);

    realdata= data(1:length(data));
   
    ecgReal= ((data/(2^16))-0.5)*300; %con esto ajustamos la amplitud
    % 3300/1100 (es decir 3) 
    %multiplicamos por 300 ya que los electrodos obtienen el voltaje en
    %microvoltios y nosotros queremos milivoltios
 

    %ajustamos el tiempo  ->  samplingRate= 1000;
    t= (1/1000);
    vect = (1:1:length(ecgReal)); %(inicio:incremento:fin)
    tiempo = vect*t;

    %centramos en cero la señal
    %ecgFinal=(ecgReal-mean(ecgReal))/std(ecgReal);


    [p,s,mu] = polyfit((1:numel(ecgReal))',ecgReal,10);
    f_y = polyval(p,(1:numel(ecgReal))',[],mu);
    ECG_data = (ecgReal - f_y);                                                                  % esto es z score o normal distribution???
    
    
    %figure;
    %subplot(1,1,1);
    %plot (tiempo,ECG_data);
    %grid on;

   %detectamos picos R -> >0.5mV y se encuentran separadas por mas de 200
   %muestras
     [pksR,locs_Rwave] = findpeaks(ECG_data,'MinPeakHeight',0.5,'MinPeakDistance',200);
     %disp(locs_Rwave);
  
    %Buscamos los picos S por minimos locales
     ECG_inverted = -ECG_data;
     [pksS,locs_Swave] = findpeaks(ECG_inverted,'MinPeakHeight',0.5,'MinPeakDistance',200);

    %Buscamos los picos de Q que estarán entre -0.2mV and -0.5mV
    [pksQ,min_locs] = findpeaks(-ECG_data,'MinPeakDistance',40);
    locs_Qwave = min_locs(ECG_data(min_locs)>-0.5 & ECG_data(min_locs)<-0.2);
    
    %figure
    %hold on
    %subplot(2,2,1);
    %plot(tiempo,ECG_data); 
    %grid on
    %title('ECG')
    %xlabel('Samples')
    %ylabel('Time (s)')

    %subplot(2,2,2);
    %plot(locs_Qwave,ECG_data(locs_Qwave),'rs','MarkerFaceColor','g');
    %grid on
    %title('Q wave')
    %xlabel('Samples')
    %ylabel('Voltage(mV)')

    %subplot(2,2,3);
    %plot(locs_Rwave,ECG_data(locs_Rwave),'rv','MarkerFaceColor','r');
    %grid on
    %title('R wave')
    %xlabel('Samples')
    %ylabel('Voltage(mV)')

    %subplot(2,2,4);
    %plot(locs_Swave,ECG_data(locs_Swave),'rs','MarkerFaceColor','b');
    %grid on
    %title('S wave')
    %xlabel('Samples')
    %ylabel('Voltage(mV)')

    maxPeak= max(pksR);

    %disp('Ondas R: ');
    %fprintf('%f\n', pksR);
    %disp('Amplitud max: ');
    %fprintf('%f\n', maxPeak);

    minPeakS = -max(pksS); %como esta invertido coger el - (valor máximo) = valor minimo
    minPeakQ = min(ECG_data(locs_Qwave));% para que los valores de Q se encuentren entre -0.2 y -0.5

    %disp('Ondas Q: ');
    %fprintf('%f\n', ECG_data(locs_Qwave));
    disp('Amplitud min Q: ');
    fprintf('%f\n', minPeakQ);
     disp('Amplitud min S: ');
    fprintf('%f\n', minPeakS);
    
    if(minPeakS>minPeakQ)
        minPeak = minPeakQ;
    else
        minPeak = minPeakS;
    end

    %function amplitudes = BITalinoFileReader(file2);
    amplitud = maxPeak + minPeak; %porque el mínimo será negativo
    %amplitudes = amplitud;
    %fprintf('%f\n', amplitudes);
    %end;

    %disp('Amplitud total')
    %fprintf('%f\n', maxPeak)
    %disp('+')
    %fprintf('%f\n', minPeak)
    %disp('=')
    %fprintf('%f\n', amplitude) -> parece que todo funciona bien

   
  
    %seguimos con la funcion
    header = {};

     fid = fopen(file2, 'r'); % esto significa abrir el archivo para leerlo (read)

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
