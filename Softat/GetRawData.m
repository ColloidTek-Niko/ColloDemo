function [ Mag, Pha, f ] = GetRawData( Dir , Method, index, omit, trendi, index2 )
% function [ Mag Pha f ] = GetRawData( Dir, Option, Index)
% Function gets magnitude, phase and frequency vectors from data file.
%
% Arguments:
%         Dir - path of the data files or the directory
%         Method - choose 'DIR' or 'FILE' (DIR if omitted)
%         Index - if option 
%
% Author:           Teemu Yli-Hallila
% Last modified:    3.6.2015


if nargin<2; Method = 'DIR'; end
if nargin<3; index = 0; end
if nargin<4; omit = 0; end
if nargin<5; trendi = 0; end
if nargin<6; index2 = 0; end

% if strcmp(Method,'FILE')
%     files = 1;
% else 
%     files = dir(fullfile(Dir, '\A*.mat'))
% end




%if isempty(files) == 0

switch Method
    case 'DIR'
    
      % optio Jos DIR ja indeksi > 0 niin palautetaan vaan indeksin 
      % osoittama magnitude ja phase
      if index > 0
            D = load([Dir 'A ' int2str(index) '.mat']); % ilma 1
            [Mag, Pha] = CalculateAverage(D);
            f = D.SweepInfo.RealizedSweepFrequencyVector';
      else
      % Muutoin palautetaan keskiarvot koko kansiosta
          
        files = dir(fullfile(Dir, 'A*.mat'));

       for a = 1:length(files)
    
        D = load([Dir 'A ' int2str(a) '.mat']); % ilma 1

        if a == 1 % alustetaan ensimmäisellä kerralla muuttujat
            Mag = zeros(length(D.SweepData(1, 1).Magnitude),length(files));
            Pha = zeros(length(D.SweepData(1, 1).Magnitude),length(files));
        end
    
        [Mag(:,a), Pha(:,a)] = CalculateAverage(D);
    
       end
            f = D.SweepInfo.RealizedSweepFrequencyVector';
            f = f(:);

      end
        %return;
       
    case 'FILE'

%         clear
%         
%         Kansio = 'C:\Users\ylihalli\Documents\Passive resonance sensor\Koesarjat\Liete'
%         Kansio = 'D:\PassiveResonanceSensor\Koesarjat\Testi\Port1'
%         Dir = [Kansio '\A ' '15' '.mat']
%         Dir = 'C:\Users\ylihalli\Dropbox\IDO\Raw1000\A 9.mat'
        
        D = load(Dir); % ilma 1
    
        Mag = zeros(length(D.SweepData(1, 1).Magnitude),length(D.SweepData(:)));
        Pha = zeros(length(D.SweepData(1, 1).Magnitude),length(D.SweepData(:)));
    
        f = D.SweepInfo.RealizedSweepFrequencyVector;
        
        if size(f,1) ~= size(Mag,1)
            f = f';
        end
    
        dim = ndims(D.SweepData(1).Magnitude);    %# Get the number of dimensions for your arrays
        M = cat(dim+1,D.SweepData(:).Magnitude);
        P = cat(dim+1,D.SweepData(:).Phase);
        
        if length(M(1,:,1)) == 1
            for a = 1:length(D.SweepData(:))
                Mag(:,a) = M(:,1,a);
                Pha(:,a) = P(:,1,a);
            end
        else
            for a = 1:length(D.SweepData(:))
                Mag(:,a) = M(1,:,a);
                Pha(:,a) = P(1,:,a);
            end
        end 
        
        if index > 0 % jos indeksi valittu, tulostetaan vain indeksin mukainen mittaus tiedostosta
            Mag = Mag(:,index);
            Pha = Pha(:,index);
        end 
          
    case 'DIRS'
      
      files = dir(fullfile(Dir, 'A*.mat')); 
      
      if index2 == 0
          index2 = length(files);
      end  
        
      % optio Jos DIR ja indeksi > 0 niin palautetaan vaan indeksin 
      % osoittama magnitude ja phase
      if index < 0.1
          index = 1;  
      end
      % Muutoin palautetaan keskiarvot koko kansiosta
                

       % lasketaan vektorin pituus alustusta varten 
       i = 1; ii = 0;
       for a = index:omit+1:index2
            ii = ii+1;
       end
        
       i = 1;
       for a = index:omit+1:index2
    
        D = load([Dir 'A ' int2str(a) '.mat']); % ilma 1

        if a == 1 % alustetaan ensimmäisellä kerralla muuttujat
            Mag = zeros(length(D.SweepData(1, 1).Magnitude),ii);
            Pha = zeros(length(D.SweepData(1, 1).Magnitude),ii);
        end
        
        [Mag(:,i), Pha(:,i)] = CalculateAverage(D);
        i = i+1;
    
       end
            f = D.SweepInfo.RealizedSweepFrequencyVector';
            f = f(:);

      
        %return;
    case 'INDEXALL'
        
        D = load(fullfile(Dir, [int2str(index) '.mat'])); % ilma 1
    
        Mag = zeros(length(D.SweepData(1, 1).Magnitude),length(D.SweepData(:)));
        Pha = zeros(length(D.SweepData(1, 1).Magnitude),length(D.SweepData(:)));
    
        f = D.SweepInfo.RealizedSweepFrequencyVector;
        
        if size(f,1) ~= size(Mag,1)
            f = f';
        end
    
        dim = ndims(D.SweepData(1).Magnitude);    %# Get the number of dimensions for your arrays
        M = cat(dim+1,D.SweepData(:).Magnitude);
        P = cat(dim+1,D.SweepData(:).Phase);
        
        if length(M(1,:,1)) == 1
            for a = 1:length(D.SweepData(:))
                Mag(:,a) = M(:,1,a);
                Pha(:,a) = P(:,1,a);
            end
        else
            for a = 1:length(D.SweepData(:))
                Mag(:,a) = M(1,:,a);
                Pha(:,a) = P(1,:,a);
            end
        end 
    
    case 'INDEX'
        
        %D = load(fullfile(Dir, [ int2str(index) '.mat'])); % ilma 1
        
       
        D = load(fullfile(Dir, [int2str(index) '.mat'])); % ilma 1
    
        Mag = zeros(length(D.SweepData(1, 1).Magnitude),1);
        Pha = zeros(length(D.SweepData(1, 1).Magnitude),1);
        
        [Mag(:,1), Pha(:,1)] = CalculateAverage(D);
        
        f = D.SweepInfo.RealizedSweepFrequencyVector';
        f = f(:);
        
    otherwise 
               
end % end switch
 
if trendi == 1
    
    for a = 1:length(Mag(1,:))
        Mag_t(:,a) = detrend(Mag(:,a));
        Pha_t(:,a) = detrend(Pha(:,a));
    end
    Mag = Mag_t;
    Pha = Pha_t;
end


%else % else if is empty
%    Mag = nan
%    Pha = nan
%    f = nan

%end % end if is empty



end % function end



