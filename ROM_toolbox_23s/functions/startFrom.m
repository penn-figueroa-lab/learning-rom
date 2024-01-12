function newStruct = startFrom(struct,Fs)
% Removes frames before starting frame
% Input: Structure and Starting Frame
% Output: Structure starting from Fs

for bones = fieldnames(struct)'
    struct.(bones{1})(1:Fs,:) = [];
end
newStruct = struct;

end