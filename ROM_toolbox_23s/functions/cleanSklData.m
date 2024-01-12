function [cleaned, tol, dataPercent] = cleanData (rawdata , markerColumn)

tol = 0.1; % mm

dataSize = size(rawdata,1); 
edit = rawdata;

for j=1:dataSize % j is the row number
    for i = j+1:dataSize
        dist = (edit(i,markerColumn:end)-edit(j,markerColumn:end)); %./edit(j,markerColumn:end);
        if max(dist) <= tol
            edit(j,:) = edit(j,:);
            edit(i,:) = 0;
        end
    end
end

idx2keep_rows    = sum(abs(edit),2)>0 ;
cleaned = edit(idx2keep_rows,:) ;
% edit( all(~edit,2), : ) = [];

dataPercent = size(cleaned,1) / dataSize * 100;

end