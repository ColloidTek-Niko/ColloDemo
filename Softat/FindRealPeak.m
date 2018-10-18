function [Index1, Index2] = FindRealPeak( Measurement, derivP2 )
% [F, NumberOfErrors, lab ] = CalculateFeatureBWP( Pha, f, Draw)
% Function calculates feature  BWP from frequency response data.
%
% Arguments:
%         Pha - Phase vector
%         f   - Frequency vector
%         Draw - figures 1 on / 0 off
%
% Author:           Teemu Yli-Hallila
% Last modified:    27.10.2016

clear k 
clear k2

k = find(derivP2);
for a = 1:length(k)
    k2(a)=k(a)-a+1;
end

clear changes
changes(1,1) = k(1);
change_count = 1;
for a = 2:length(k2)
    if(k2(a) ~= k2(a-1))
        changes(change_count,2) = k(a-1);
        change_count = change_count+1;
       % changes(change_count,1:2) = 0;
        changes(change_count,1) = k(a);
    end
end
changes(change_count,2) = k(end);


for a = 1:length(changes(:,1))
    index_abs(a) = abs(max(Measurement(changes(a,1):changes(a,2)))-min(Measurement(changes(a,1):changes(a,2))));
end

[~,real_peak_index] = max(index_abs);

Index1 = changes(real_peak_index,1);
Index2 = changes(real_peak_index,2);



end % function end





