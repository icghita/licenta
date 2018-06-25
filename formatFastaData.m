function formatedOutput = formatFastaData(fastaData)
%Transforma o serie de secvente Fasta intr-un vector de celule echivalente
%seriei de atomi dintrun fisier PDBx/mmCIF 
    keys = {'Ala','Arg','Asn','Asp','Cys','Gln','Glu','Gly','His','Ile','Leu','Lys','Met','Phe','Pro','Ser','Thr','Trp','Tyr','Val','Asx','Glx','Xaa'};
    values = {{'N', 'C', 'C', 'O', 'C', ; 'N', 'CA', 'C', 'O', 'CB'  },
            {'N', 'C', 'C', 'O', 'C', 'C', 'C', 'N', 'C', 'N', 'N', ; 'N', 'CA', 'C', 'O', 'CB', 'CG', 'CD', 'NE', 'CZ', 'NH1', 'NH2'  },
            {'N', 'C', 'C', 'O', 'C', 'C', 'O', 'N', ; 'N', 'CA', 'C', 'O', 'CB', 'CG', 'OD1', 'ND2'  },
            {'N', 'C', 'C', 'O', 'C', 'C', 'O', 'O', ; 'N', 'CA', 'C', 'O', 'CB', 'CG', 'OD1', 'OD2'  },
            {'N', 'C', 'C', 'O', 'C', 'S', ; 'N', 'CA', 'C', 'O', 'CB', 'SG'  },
            {'N', 'C', 'C', 'O', 'C', 'C', 'C', 'O', 'N', ; 'N', 'CA', 'C', 'O', 'CB', 'CG', 'CD', 'OE1', 'NE2'  },
            {'N', 'C', 'C', 'O', 'C', 'C', 'C', 'O', 'O', ; 'N', 'CA', 'C', 'O', 'CB', 'CG', 'CD', 'OE1', 'OE2'  },
            {'N', 'C', 'C', 'O', ; 'N', 'CA', 'C', 'O'  },
            {'N', 'C', 'C', 'O', 'C', 'C', 'N', 'C', 'C', 'N', ; 'N', 'CA', 'C', 'O', 'CB', 'CG', 'ND1', 'CD2', 'CE1', 'NE2'  },
            {'N', 'C', 'C', 'O', 'C', 'C', 'C', 'C', ; 'N', 'CA', 'C', 'O', 'CB', 'CG1', 'CG2', 'CD1'  },
            {'N', 'C', 'C', 'O', 'C', 'C', 'C', 'C', ; 'N', 'CA', 'C', 'O', 'CB', 'CG', 'CD1', 'CD2'  },
            {'N', 'C', 'C', 'O', 'C', 'C', 'C', 'C', 'N', ; 'N', 'CA', 'C', 'O', 'CB', 'CG', 'CD', 'CE', 'NZ'  },
            {'N', 'C', 'C', 'O', 'C', 'C', 'S', 'C', ; 'N', 'CA', 'C', 'O', 'CB', 'CG', 'SD', 'CE'  },
            {'N', 'C', 'C', 'O', 'C', 'C', 'C', 'C', 'C', 'C', 'C', ; 'N', 'CA', 'C', 'O', 'CB', 'CG', 'CD1', 'CD2', 'CE1', 'CE2', 'CZ'  },
            {'N', 'C', 'C', 'O', 'C', 'C', 'C', ; 'N', 'CA', 'C', 'O', 'CB', 'CG', 'CD'  },
            {'N', 'C', 'C', 'O', 'C', 'O', ; 'N', 'CA', 'C', 'O', 'CB', 'OG'  },
            {'N', 'C', 'C', 'O', 'C', 'O', 'C', ; 'N', 'CA', 'C', 'O', 'CB', 'OG1', 'CG2'  },
            {'N', 'C', 'C', 'O', 'C', 'C', 'C', 'C', 'N', 'C', 'C', 'C', 'C', 'C', ; 'N', 'CA', 'C', 'O', 'CB', 'CG', 'CD1', 'CD2', 'NE1', 'CE2', 'CE3', 'CZ2', 'CZ3', 'CH2'  },
            {'N', 'C', 'C', 'O', 'C', 'C', 'C', 'C', 'C', 'C', 'C', 'O', ; 'N', 'CA', 'C', 'O', 'CB', 'CG', 'CD1', 'CD2', 'CE1', 'CE2', 'CZ', 'OH'  },
            {'N', 'C', 'C', 'O', 'C', 'C', 'C', ; 'N', 'CA', 'C', 'O', 'CB', 'CG1', 'CG2'  },
            {'N', 'C', 'C', 'O', 'C', 'C', 'O', 'N', ; 'N', 'CA', 'C', 'O', 'CB', 'CG', 'OD1', 'ND2'  },
            {'N', 'C', 'C', 'O', 'C', 'C', 'C', 'O', 'N', ; 'N', 'CA', 'C', 'O', 'CB', 'CG', 'CD', 'OE1', 'NE2'  },
            {'N', 'C', 'C', 'O', 'C', ; 'N', 'CA', 'C', 'O', 'CB'  }
            };
    %Fiecare reziduu are o structura in formatul PDB care contine atomii
    %coloanei sale vertebrale. Corespondenta reziduu-coloana este retinuta
    %in dictionarul aminoacidMap
    aminoacidMap = containers.Map(keys, values);
    formatedOutput = {};
    chainSymbol = 65;
    atomIndex = 1;
    %Pentru fiecare reziduu din fisierul .fasta, un numar de linii este
    %scris in fisierul PDB, unic pentru fiecare reziduu
    for i=1:length(fastaData)
        chainResidueIndex = 1;
        for j=1:length(fastaData(i).Sequence)
            aminoacidStructure = aminoacidMap(aminolookup(fastaData(i).Sequence(j)));
            for k=1:length(aminoacidStructure)
                formatedOutput{end+1, 1} = 'ATOM';
                formatedOutput{end, 2} = num2str(atomIndex);
                formatedOutput{end, 3} = aminoacidStructure{1,k};
                formatedOutput{end, 4} = aminoacidStructure{2,k};
                formatedOutput{end, 5} = '.';
                formatedOutput{end, 6} = upper(aminolookup(fastaData(i).Sequence(j)));
                formatedOutput{end, 7} = char(chainSymbol);
                formatedOutput{end, 8} = '1';
                formatedOutput{end, 9} = num2str(chainResidueIndex);
                formatedOutput{end, 10} = '?';
                formatedOutput{end, 11} = '0.0';
                formatedOutput{end, 12} = '0.0';
                formatedOutput{end, 13} = '0.0';
                formatedOutput{end, 14} = '1.00';
                formatedOutput{end, 15} = '30.00';
                formatedOutput{end, 16} = '?';
                formatedOutput{end, 17} = num2str(chainResidueIndex);
                formatedOutput{end, 18} = formatedOutput{end, 6};
                formatedOutput{end, 19} = char(chainSymbol);
                formatedOutput{end, 20} = aminoacidStructure{2,k};
                formatedOutput{end, 21} = '1';
                atomIndex = atomIndex + 1;
            end
            chainResidueIndex = chainResidueIndex + 1;
        end
        chainSymbol = chainSymbol + 1;
    end
end
