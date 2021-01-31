function filepath = mfilepath()
% MFILEPATH()
%
% Returns the full filepath of the caller of this function.
%
% If a script calls this function, path to the folder containing
% the script is returned.
%
% Calling this function from the command line returns an empty character
% array.

path = dbstack('-completenames',1);
filepath = '';

if(~isempty(path))
    filepath = path.file;

    if ispc
        i = find(filepath=='\', 1, 'last');
    else
        i = find(filepath=='/', 1, 'last');
    end
    filepath = filepath(1:i-1);
end    


end