Dir =cd;
index =  regexpi(Dir ,'Demo');
addpath(genpath([Dir(1:index+3) '\']))

warning off
Data_folder = [Dir(1:index+3) '\opetus\'];

[Mag, Pha, f] = GetRawData(Data_folder);
[IntT, ExtT] = GetTemperatures(Data_folder);
[Time, Annotation, Timenum] = GetMeasurementInfo(Data_folder);

[FeatureVector, NumberOfErrors ] = CalculateFeatureBWG( Mag, f);
save([Data_folder,'FeaturesBWG.mat'],'FeatureVector');
BWG = FeatureVector; clear FeatureVector;

      
[FeatureVector, NumberOfErrors ] = CalculateFeatureFG(Mag,f);
save([Data_folder,'FeaturesFG.mat'],'FeatureVector');
FG = FeatureVector; clear FeatureVector;
