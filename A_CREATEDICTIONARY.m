function map = A_CREATEDICTIONARY()
[atomData, hetatomData] = readData('C:\Users\asus\Desktop\Scoala\Licenta\ann-protein-struct\4d2i.cif');
keys = {};
values = {};
for i = 1:20
    keys{end+1} = aminolookup(int2aa(i));
    j = 1;
    ok1 = 1;
    while ok1 && j <= length(atomData)
        if(strcmpi(atomData(j, 6), keys(end)))
            ok2 = 1;
            l = j;
            aux = {};
            while ok2
                aux(1,end+1) = atomData(l, 3);
                aux(2,end) = atomData(l, 4);
                if(str2num(atomData{l, 9}) ~= str2num(atomData{l+1, 9}))
                    ok2 = 0;
                    values{end+1} = aux;
                end
                l = l + 1;
            end
            ok1 = 0;
        end
        j = j + 1;
    end
end
map = containers.Map(keys, values);
vals = map.values;
fileID = fopen('idctionary.txt','w');
for i=1:length(vals)
    fprintf(fileID, '{');
    for j=1:length(vals{i})
        fprintf(fileID, '''%s'', ', cell2mat(vals{i}(1,j)));
    end
    fprintf(fileID, '; ');
    for j=1:length(vals{i})-1
        fprintf(fileID, '''%s'', ', cell2mat(vals{i}(2,j)));
    end
    fprintf(fileID, '''%s'' ', cell2mat(vals{i}(2,j+1)));
    fprintf(fileID, ' },\n');
end
fclose(fileID);