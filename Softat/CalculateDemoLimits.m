function [ sample ] = CalculateDemoLimits( sample, minvalue, maxvalue)
% Laskee aine-demon rajat sille sy�tetyist� inputeista.
%
% Inputteina n�ytteet structeina, jotka sis�lt�v�t BWG ja FG arvot.
% 
%   minvalue: m��ritt�� k�ytet��k� rajoissa minimiarvoja vai ei [0 1]
%   maxvalue: m��ritt�� k�ytet��k� rajoissa maksimiarvoja vai ei [0 1]

if nargin<2; minvalue = 1; end
if nargin<3; maxvalue = 1; end

global DEMO

% M��ritell��n MARGINAALIEN maksimi ja minimi-arvot (eli erotus yl�s ja alas)
if minvalue
    minFG = 0.10/2; %0.10 /2;
    minBWG = 0.0050/2; %0.0050/2;
else
    minFG = 0;
    minBWG = 0;
end

if maxvalue
    maxFG = 0.15/2;
    maxBWG = 0.02/2;
else
    maxFG = 0;
    maxBWG = 0;
end

if length(sample) ~= 3
    error('N�ytteiden m��r� vektorissa ei ole kolme!');
end

    
sample(1).limit_FG = [0 0];
sample(2).limit_FG = [0 0];
sample(3).limit_FG = [0 0];

%%
% Lasketaan FG rajat
for i = 1:length(sample) 
    FG =  [sample(:).FG];

    if sample(i).FG == min(FG) % Etsit��n pienin arvo
        FG(i) = inf;
        
        for n = 1:length(sample) 
            if sample(n).FG == min(FG) % Etsit��n toiseksi pienin arvo
                
                marginaali = min(max((sample(n).FG - sample(i).FG)/2, minFG), maxFG);
                
                % asetetaan pienimm�lle arvolle rajat
                sample(i).limit_FG = [sample(i).FG - marginaali, ...
                    sample(i).FG + marginaali - 0.0001];
                
                % asetetaan toiseksi pienimm�lle arvolle ala-raja
                sample(n).limit_FG(1) = sample(n).FG - marginaali;
            end
        end
    end
    
    if sample(i).FG == max(FG) % etsit��n suurin arvo
        FG(i) = 0;
        
        for n = 1:length(sample) 
            if sample(n).FG == max(FG) % Etsit��n toiseksi pienin arvo
                
                marginaali = min(max((sample(i).FG - sample(n).FG)/2, minFG), maxFG);
                
                 % asetetaan suurimmalle arvolle rajat
                sample(i).limit_FG = [sample(i).FG - marginaali, ...
                    sample(i).FG + marginaali];
                
                % asetetaan toiseksi pienimm�lle arvolle yl�-raja
                sample(n).limit_FG(2) = sample(n).FG + marginaali - 0.0001;
            end
        end
    end
end

%%
% Lasketaan BWG rajat
for i = 1:length(sample) 
    BWG =  [sample(:).BWG];

    if sample(i).BWG == min(BWG) % Etsit��n pienin arvo
        BWG(i) = inf;
        
        for n = 1:length(sample) 
            if sample(n).BWG == min(BWG) % Etsit��n toiseksi pienin arvo
                
                marginaali = min(max((sample(n).BWG - sample(i).BWG)/2, minBWG), maxBWG);
                
                % asetetaan pienimm�lle arvolle rajat
                sample(i).limit_BWG = [sample(i).BWG - marginaali, ...
                    sample(i).BWG + marginaali - 0.0001];
                
                % asetetaan toiseksi pienimm�lle arvolle ala-raja
                sample(n).limit_BWG(1) = sample(n).BWG - marginaali;
            end
        end
    end
    
    if sample(i).BWG == max(BWG) % etsit��n suurin arvo
        BWG(i) = 0;
        
        for n = 1:length(sample) 
            if sample(n).BWG == max(BWG) % Etsit��n toiseksi pienin arvo
                
                marginaali = min(max((sample(i).BWG - sample(n).BWG)/2, minBWG), maxBWG);
                
                 % asetetaan suurimmalle arvolle rajat
                sample(i).limit_BWG = [sample(i).BWG - marginaali, ...
                    sample(i).BWG + marginaali];
                
                % asetetaan toiseksi pienimm�lle arvolle yl�-raja
                sample(n).limit_BWG(2) = sample(n).BWG + marginaali - 0.0001;
            end
        end
    end
end



%%
try
    save([DEMO.dir_opetus '\limit_values'], 'sample');
catch
    disp('Tallennus ei onnistu')
end


end






