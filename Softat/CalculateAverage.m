function [ Mag, Pha ] = CalculateAverage( D )
% [ AverageMagnitude AveragePhase ] = CalculateAverage( DataStructure )
%
% Author:           Teemu Yli-Hallila
% Last modified:    3.6.2015

        dim = ndims(D.SweepData(1).Magnitude);    %# Get the number of dimensions for your arrays
        M = cat(dim+1,D.SweepData(:).Magnitude);  %# Convert to a (dim+1)-dimensional matrix
        Mag = mean(M,dim+1);                 %# Get the mean across arrays
        Mag = Mag(:)';

        dim = ndims(D.SweepData(1).Phase);         
        M = cat(dim+1,D.SweepData(:).Phase);        
        Pha = mean(M,dim+1);     
        Pha = Pha(:)';
        
end % function end
