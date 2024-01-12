function [cleaned, dataKeepPercent] = cleanData (data)

tol = 0.05; % degree

dataSize = size(data,1); 
edit = data;

for j=1:dataSize % j is the row number
    for i = j+1:dataSize
        dist = (edit(i,:)-edit(j,:)); %./edit(j,:);
        if norm(dist) <= tol
            edit(j,:) = edit(j,:);
            edit(i,:) = 0;
        end
    end
end

idx2keep_rows    = sum(abs(edit),2)>0 ;
cleaned = edit(idx2keep_rows,:) ;
% edit( all(~edit,2), : ) = [];

dataKeepPercent = size(cleaned,1) / dataSize * 100;

end