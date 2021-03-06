function [ sample_limits ] = ReadSamples(laite_nro, tiedostot_valmiina)
% Lukee kolme n�ytett�

if nargin<2, tiedostot_valmiina = 0; end
warning off

global DEMO

Data_folder = [DEMO.dir_opetus '\'];

opetustiedosto = ['Opetus_demosetti1.bat'; 'Opetus_demosetti2.bat'];

files = dir(fullfile(Data_folder, 'A*.mat'));

if isempty(files)
    temp_dir = cd;
    cd(DEMO.dir_opetus);
    
    for i = 1:3
        name(i) = (inputdlg(['Aseta n�yte ' num2str(i) ' mittausalustalle ja sy�t� nimi'],...
            ['N�yte ' num2str(i)], [1 50]));
        
        system([DEMO.dir_opetus opetustiedosto(laite_nro,:)]);
    end
    cd(temp_dir), clear temp_dir
elseif tiedostot_valmiina
    
    option = 2;
    load(fullfile(Data_folder, '\limit_values.mat'));
    for i=1:3, name(i) = {sample(i).name}; end
else
    choice = questdlg('Vanhoja n�ytteit� l�ytyi opetus kansiosta!', ...
	'Vanhoja tiedostoja l�ytyi', ...
	'Poista ja mittaa uudet','Lue rajat olemassa olevista tiedostoista','Peruuta','Peruuta');

    switch choice
        case 'Poista ja mittaa uudet'
            option = 1;
            disp(['Poistetaan tiedostot!'])
            
            temp_dir = cd;
            cd(DEMO.dir_opetus);
            
            delete 'A*.mat' 'T*.mat'
            delete FeaturesBWG.mat FeaturesFG.mat MeasurementInfo.mat
            for i = 1:3
                 name(i) = (inputdlg(['Aseta n�yte ' num2str(i) ' mittausalustalle ja sy�t� nimi'],...
                    ['N�yte ' num2str(i)], [1 50]));
                 system([DEMO.dir_opetus '\' opetustiedosto(laite_nro,:)]);
            end
            cd(temp_dir); clear temp_dir
            
        case 'Lue rajat olemassa olevista tiedostoista'
            option = 2;
            
            for i = 1:3
                name(i) = (inputdlg(['Sy�t� tiedostossa A' num2str(i) ' olevan n�ytteen nimi'],...
                    ['N�yte ' num2str(i)], [1 50]));
            end
            
        case 'Peruuta'
            option = 3;
            
    end          
end    

if option == 1 || option == 2
    [Mag, Pha, f] = GetRawData(Data_folder);
    [IntT, ExtT] = GetTemperatures(Data_folder);
    [Time, Annotation, Timenum] = GetMeasurementInfo(Data_folder);

    [FeatureVector, NumberOfErrors ] = CalculateFeatureBWG( Mag, f);
    save([Data_folder,'FeaturesBWG.mat'],'FeatureVector');
    BWG = FeatureVector; clear FeatureVector;

    [FeatureVector, NumberOfErrors ] = CalculateFeatureFG(Mag,f);
    save([Data_folder,'FeaturesFG.mat'],'FeatureVector');
    FG = FeatureVector; clear FeatureVector;

    sample = struct([]);
    
    for i = 1:3
        sample(i).FG = FG(i);
        sample(i).BWG = BWG(i);
        sample(i).name = char(name(i));
    end

    sample_limits = CalculateDemoLimits(sample);
end

end

