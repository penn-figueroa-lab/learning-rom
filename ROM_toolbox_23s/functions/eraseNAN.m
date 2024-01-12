function newStruct = eraseNAN(struct)
% Removes frames with NAN values

for bones = fieldnames(struct)'
    [rows, columns] = find(isnan(struct.(bones{1})));
    for nanbone = fieldnames(struct)'
        struct.(nanbone{1})(rows,:) = [];
    end
end
newStruct = struct;
fprintf('Frames with NAN = %c\n\n\n',rows);

end