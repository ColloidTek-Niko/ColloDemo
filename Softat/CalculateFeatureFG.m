function [F, NumberOfErrors, MAG, p1, p2, p3 ] = CalculateFeatureFG( Magnitude,f,  Draw)
% [F, NumberOfErrors, MAG, p1, p2, p3 ] = CalculateFeatureFG( Magnitude,f,  Draw)
% Function calculates feature FG from FR data.
%
% Arguments:
%         Magnitude
%         f   - Frequency vector
%         Draw 0 off (default) / 1 on
%
% Author:           Teemu Yli-Hallila
% Last modified:    28.10.2015


if nargin<3; Draw = 0; end



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Alustukset
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i = 1;  
NumberOfErrors = 0;
kf =1/1000000;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Magnitude - analyysi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Testiarvot
        
%         load('C:\Local\ylihalli\CaseMirka\Koe2\Ala_anturi\A 1234.mat')
%         Magnitude = SweepData(1).Magnitude  ;
%         f = SweepInfo.RealizedSweepFrequencyVector  ;
%         Draw = 1;
%         b=1;



for b=1:length(Magnitude(1,:))
    try
         for a = 51:length(Magnitude(:,b))-50
     
            testiM = Magnitude(a-50,b) >  Magnitude(a,b) && Magnitude(a-50,b) < 0 && Magnitude(a,b) < 0;
            testiM2 = Magnitude(a+50,b) > Magnitude(a,b) && Magnitude(a+50,b) < 0 && Magnitude(a,b) < 0;
    
            deriv(a) = testiM == 1  && testiM2 == 1;

         end

         testiM3 = Magnitude(:,b);
         
         [ala,yla] = FindRealPeak(Magnitude(:,b),deriv);
         [~, indP2] = min(testiM3(ala:yla));
         index = ala+indP2-1;
         
        if Draw == 1 % plotataan
            figure(1)
            plot(deriv,'r'); hold on
            plot(Magnitude(:,b)); hold off
        end
        
        % Vaihe 2
        
        MagR = Magnitude(index-40:index+40,b);
        fR = f(index-40:index+40,1);
        p = polyfit(fR,MagR,4);
        p_ref = polyfit(fR,MagR,2); % toisen kertaluvun sovite - referenssi
        
        p1 = p_ref(1); p2 = p_ref(2); p3 = p_ref(3); % palautteet

        dp = polyder(p);
        root_zdf = roots(dp);
        [~,root_index] = min(abs( roots(dp)-roots(polyder(p_ref))));
        zdf = root_zdf(root_index); % palaute FG
        
        MAG = polyval(p,zdf); % palaute MAG
        

        if Draw == 1 % plotataan
            figure(2)
            plot(fR,MagR,'bo'); hold on
            plot(fR,polyval(p,fR),'or'); 
            line([zdf zdf],[polyval(p,zdf) max(MagR)],'color','k')
            plot(zdf,polyval(p,zdf),'kx')
            hold off
        end
        

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

        feat_f(i) = zdf;
        i = i+1;
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    catch
        NumberOfErrors = NumberOfErrors+1;
        i = i+1;
        b;
	end % try end

end % for end
        

    F = feat_f*kf;


end % function end





