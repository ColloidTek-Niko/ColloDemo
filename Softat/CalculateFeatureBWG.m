function [F, NumberOfErrors ] = CalculateFeatureBWG( Magnitude, f, Draw)
% [feature 1, feature 2, NumberOfErrors ] = GetFeatures( Mag, Pha, f)
% Function calculates features from the frequency response data.
%
% Arguments:
%         Mag - Magnitude vector
%         Pha - Phase vector
%         f   - Frequency vector
%
% Author:           Teemu Yli-Hallila
% Last modified:    3.6.2015

if nargin<3; Draw = 0; end


i = 1;  
NumberOfErrors = 0;
kf =1/1000000;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Magnitude - analyysi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Lasketaan magnitudevektoreista resonanssipiikin huiput (BWG)
% clear
% load('C:\Users\ylihalli\Documents\Passive resonance sensor\Koesarjat\Referenssit\Port0\A 21.mat')
% load('C:\Users\ylihalli\Dropbox\new_virheelliset\A 5.mat')
% 
% Magnitude = SweepData(1, 1).Magnitude
% Pha = SweepData(1, 1).Phase
% f = SweepInfo.RealizedSweepFrequencyVector'
% b=1
% Magnitude = detrend(Magnitude)
%Magnitude = Mag

% plot(f, Magnitude)
% figure
% plot(f, detrend(Magnitude))


% me = mean(Magnitude)

%Magnitude = detrend(Magnitude);

%Magnitude = Magnitude+me


for b=1:length(Magnitude(1,:))
    try
        
         % Vaihe 1
         FirstTime = true;
         previous = false;
         for a = 141:length(Magnitude(:,b))-140
     
            testiM = Magnitude(a-140,b) >  Magnitude(a,b) && Magnitude(a-140,b) < 0 && Magnitude(a,b) < 0;
            testiM2 = Magnitude(a+140,b) > Magnitude(a,b) && Magnitude(a+140,b) < 0 && Magnitude(a,b) < 0;
    
            if previous ==1 && testiM == 0  | testiM2 == 0 && FirstTime == 1;
                FirstTime = false;
            end
            
            deriv(a) = testiM == 1  && testiM2 == 1 && FirstTime == 1;
    
            if testiM == 1 && testiM2 == 1 && FirstTime == 1
                ind = a;
            end
   
            previous = deriv(a);
            
            %deriv(a) = Magnitude(a-4,1)+Magnitude(a-3,1)+Magnitude(a-2,1)+Magnitude(a-1,1)+Magnitude(a,1) <  Magnitude(a+1,1)+Magnitude(a+2,1)+Magnitude(a+3,1)+Magnitude(a+4,1)+Magnitude(a+5,1);
        end

        testiM3 = Magnitude(:,b);

        [~, ind2] = min(testiM3(deriv));
        ind77 = length(testiM3(deriv))-ind2;
        index = ind-ind77;
        
        
        if Draw == 1 % plotataan
            figure(1)
            plot(deriv,'r'); hold on
            plot(Magnitude(:,b)); hold off
        end

        % Vaihe 2
        
        MagR = Magnitude(index-15:index+16,b);
        fR = f(index-15:index+16,1);

        p = polyfit(fR,MagR,2);

        if Draw == 1 % plotataan
            figure(2)
            plot(fR,MagR,'bo'); hold on
            plot(fR,polyval(p,fR),'or'); hold off
        end
        
        % Vaihe 3
        
        dp = polyder(p);
        zdf = roots(dp);
        

        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % T‰st‰ eteenp‰in BWG-feature
        
    % etsit‰‰n maksimit
    
        %huippu_lin = min([max(Magnitude(1:index,b)) max(Magnitude(index:end,b))])
        
        huippu = polyval(p,zdf);
        x = [f(1) f(end)];
%         y = [huippu-(huippu-huippu_lin)*(1/4) huippu-(huippu-huippu_lin)*(1/4)];
        y = [(huippu)*0.7 huippu*0.7];

        % etsit‰‰n alempi
        for a = 1:index
            index_temp = index-a;
                 if Magnitude(index_temp,b) > huippu*0.7
                 ala_index = index_temp;
                 break;
                 end
        end
    
        % etsit‰‰n ylempi
        for a = index:length(f)
             if Magnitude(a,b) > huippu*0.7
                yla_index = a;
             break;
             end
        end
    
        
        
        % alempi sovite
        po = ala_index;
        le = 10; %sovitteen leveys

        pp = polyfit(f(po-le:po+le),Magnitude(po-le:po+le,b),1);
        ff = polyval(pp,f(po-le:po+le));

        x1 = [f(po-le) f(po+le)];
        y1 = [ff(1) ff(end)];

        [xi, ~] = polyxpoly(x1, y1, x, y); % alempi taajuusarvo

        % ylempi sovite
        po2 = yla_index;
        le = 10; %sovitteen leveys
        pp = polyfit(f(po2-le:po2+le),Magnitude(po2-le:po2+le,b),1);
        ff2 = polyval(pp,f(po2-le:po2+le));

        x2 = [f(po2-le) f(po2+le)];
        y2 = [ff2(1) ff2(end)];

        [xii, ~] = polyxpoly(x2, y2, x, y); % ylempi taajuusarvo

        leveys(i) = xii-xi;

        % plottaukset
        if Draw == 1 % plotataan
            figure(3)
            plot(f,Magnitude(:,b))
            hold on
            line([zdf zdf],[huippu 0],'color','k')
            line(x, y,'color','r')
            % line([f(ala_index) f(ala_index)],[-20 0],'color','k')
            % line([f(yla_index) f(yla_index)],[-20 0],'color','k')
            plot(f(po-le:po+le),ff,'-r')
            plot(f(po2-le:po2+le),ff2,'-r')
            hold off
        end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


     % kasvatetaan vektorin indeksi‰ tai errorien lukum‰‰r‰‰

     i = i+1;
    
    catch
        NumberOfErrors = NumberOfErrors+1;
        leveys(i) = 0;
        i = i+1;
	end % try end

end % for end
        

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Funktion palautukset
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Feature struct

    F = leveys*kf;

end % function end





