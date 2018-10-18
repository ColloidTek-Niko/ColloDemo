function [IntT, ExtT] = GetTemperatures(Folder)
% [feature 1, feature 2, NumberOfErrors, lab ] = GetFeatures2( Mag, Pha, f, FeatureX, FeatureY, Draw, Folder )
% Function gets temperatures
%
% Author:           Teemu Yli-Hallila
% Last modified:    07.09.2015


% Kansion hakeminen

    pituus = length(Folder);
 
    while pituus > 0
        if Folder(pituus) == '\';
            t_kansio = [Folder(1:pituus) 'Temp\'];
            break;
        end
        pituus = pituus-1;
    end

    if exist(t_kansio,'dir') == 7

    files = dir(fullfile(t_kansio, '\T*.mat'));
    
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Temperature
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

       %Folder = 'E:\PassiveResonanceSensor\Koesarjat\Testi\Port0'
       
       % Tarkistetaan onko Feature jo laskettu
       try
            load([Folder '\Temperature.mat'])% muuta FG.mat BWG.mat yms.
            
            if length(IntT) < length(files) % loaditetaan loput ja tallennetaan
                
                ExtT_Temp = ExtT; ExtT = 0;
                IntT_Temp = IntT; IntT = 0;
                 
                i = 1;    
                for a = length(IntT_Temp)+1:length(files)
                    load([t_kansio 'T ' int2str(a) '.mat'])
                    ExtT(i) = ExternalTemp;
                    IntT(i) = InternalTemp;
                    i=i+1;
                end
               
          	ExtT = [ExtT_Temp ExtT];
           	IntT = [IntT_Temp IntT];
                
                if exist(Folder,'dir') == 7
                    save([Folder '\Temperature.mat'],'ExtT', 'IntT' );% muuta FG.mat BWG.mat yms.
                end
            
            end
            
       catch
        %lasketaan kokonaan
           
           for a = 1:length(files)
              load([t_kansio 'T ' int2str(a) '.mat'])
              ExtT(a) = ExternalTemp;
              IntT(a) = InternalTemp;
           end
           %tallennetaan uusi
            if exist(Folder,'dir') == 7
                save([Folder '\Temperature.mat'],'ExtT', 'IntT' );% muuta FG.mat BWG.mat yms.
            end
       end
        
        
    else
        
        try
           load([Folder '\Temperature.mat'])% jos löytyy valmiiksi laskettuna, niin load
        catch
            IntT = nan;
            ExtT = nan;
        end 
        
    end



end % function end


































