function [atomData, hetatomData] = readData(filepath)
    fid = fopen(filepath);
    tline = fgetl(fid);
    atomData = {};
    hetatomData = {};
    i=0;
    while ischar(tline)
        words = strsplit(tline);
        if(strcmp(words{1}, 'ATOM') && length(words) == 22)
            atomData = [atomData; words];
        end
 %       if(strcmp(words{1}, 'HETATM'))
 %           hetatomData = [hetatomData; words];
 %       end
        tline = fgetl(fid);
        i=i+1;
    end
    fclose(fid);
end