function createSimulatedData(nbrOfFilesInEachClass)

disp('Deleting old temporary files')
delete temp/neg/*
delete temp/pos/*
delete temp/zero/*

disp('Painting images in temp folder...')
filename = 1;

for i = 1:nbrOfFilesInEachClass
    
    generateImg_pos(filename);
    generateImg_neg(filename);
    generateImg_zero(filename);
    
    filename = filename + 1;
    
end

disp('Done')

end