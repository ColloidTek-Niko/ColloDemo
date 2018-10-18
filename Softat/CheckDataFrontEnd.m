function [ truefalse ] =  CheckDataFrontEnd(Dir, mittaus_index, limits)
% Tarkistaa onko data alku ja loppu p‰‰ss‰ samanlaista

if nargin<3; limits = 0; end


[ Mag, Pha, f ] = GetRawData( Dir , 'INDEXALL', mittaus_index );


if length(Mag(1,:)) < 2
    error('Liian v‰h‰n mittauksia')
end

index = floor(length(Mag(1,:))/2);

Mag1 = mean(Mag(:,1:index),2);	%# Get the mean across arrays
% Mag1 = Mag1(:)';

Mag2 = mean(Mag(:,index:end),2);    %# Get the mean across arrays
% Mag2 = Mag2(:)';


[FeatureVector, NumberOfErrors ] = CalculateFeatureBWG( Mag1, f);
BWG1 = FeatureVector; clear FeatureVector;
[FeatureVector, NumberOfErrors ] = CalculateFeatureFG(Mag1,f);
FG1 = FeatureVector; clear FeatureVector;

[FeatureVector, NumberOfErrors ] = CalculateFeatureBWG( Mag2, f);
BWG2 = FeatureVector; clear FeatureVector;
[FeatureVector, NumberOfErrors ] = CalculateFeatureFG(Mag2,f);
FG2 = FeatureVector; clear FeatureVector;

if BWG1 <= BWG2+0.005 && BWG1 >= BWG2-0.005 && ...
        FG1 <= FG2 + 0.01 && FG1 >= FG2-0.01
    truefalse = 1;
else
    truefalse = 0;
end

BWG = mean([BWG1 BWG2]);
FG = mean([FG1 FG2]);

if  truefalse == 1
    for i = 1:length(limits)
         
        if FG > limits(i).limit_FG(1) && ...
                FG < limits(i).limit_FG(2)
            
            if BWG > limits(i).limit_BWG(1) && ...
                    BWG < limits(i).limit_BWG(2)
                
                truefalse = 1;
                break
            end
            
        elseif i == 3
            truefalse = 0;
        end
    end
end

end

