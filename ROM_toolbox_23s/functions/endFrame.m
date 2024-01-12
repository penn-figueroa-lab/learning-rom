function newStruct = endFrame(struct,Fe)
% Removes frames before starting frame
% Input: Structure and Starting Frame
% Output: Structure starting from Fs

for bones = fieldnames(struct)'
    struct.(bones{1})(Fe+1:end,:) = [];
end
newStruct = struct;

end