function [Time, Annotation, Timenum] = GetMeasurementInfo(Folder)
% [feature 1, feature 2, NumberOfErrors, lab ] = GetFeatures2( Mag, Pha, f, FeatureX, FeatureY, Draw, Folder )
% Function gets measurement info (Measurement time and annotation)
%
%
% Author:           Teemu Yli-Hallila
% Last modified:    07.09.2015


% Kansion hakeminen


    files = dir(fullfile(Folder, '\A*.mat'));
    
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Temperature
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

       % Folder = 'E:\PassiveResonanceSensor\Koesarjat\Testi\Port0'
       
       % Tarkistetaan onko Feature jo laskettu
       try
            load([Folder '\MeasurementInfo.mat'])% muuta FG.mat BWG.mat yms.
            
            if length(Time) < length(files) % loaditetaan loput ja tallennetaan
                
                Time_Temp = Time; Time = 0;
                Annotation_Temp = Annotation; Annotation = '';
                Timenum_Temp = Timenum; Timenum = 0;
                 
                i = 1;    
                for a = length(Time_Temp)+1:length(files)
               	load([Folder '\A ' int2str(a) '.mat'])
                a_temp = dir([Folder '\A ' int2str(a) '.mat']);
               	Time(i) = {a_temp.date};
                Timenum(i) = a_temp.datenum;
                    if isempty(Annotations.Annotation2)
                        Annotation(i) = {['Mittaus ' int2str(a)]};
                    else
                        Annotation(i) = {Annotations.Annotation2};
                    end
                    i=i+1;
                end
                      
          	Time = [Time_Temp Time];
           	Annotation = {[Annotation_Temp Annotation]};
            Timenum = [Timenum_Temp Timenum];
                
                if exist(Folder,'dir') == 7
                    save([Folder '\MeasurementInfo.mat'],'Time', 'Annotation','Timenum' );% muuta FG.mat BWG.mat yms.
                end
            
            end
            
       catch
        %lasketaan kokonaan
           
           for a = 1:length(files)
              	load([Folder '\A ' int2str(a) '.mat'])
                a_temp = dir([Folder '\A ' int2str(a) '.mat']);
               	Time(a) = {a_temp.date};
                Timenum(a) = a_temp.datenum;
                if isempty(Annotations.Annotation2)
                    Annotation(a) = {['Mittaus ' int2str(a)]};
                else
                    Annotation(a) = {Annotations.Annotation2};
                end
             	
           end
           %tallennetaan uusi
            if exist(Folder,'dir') == 7
                save([Folder '\MeasurementInfo.mat'],'Time', 'Annotation','Timenum' );% muuta FG.mat BWG.mat yms.
            end
       end
        
        


end % function end































