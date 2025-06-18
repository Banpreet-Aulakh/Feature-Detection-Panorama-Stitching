function convert_jpeg_to_png_in_current_folder()
    current_folder = pwd;  
    
    jpeg_files = dir(fullfile(current_folder, '*.jpg'));
    jpeg_files = [jpeg_files; dir(fullfile(current_folder, '*.jpeg'))]; 
    
    png_files = dir(fullfile(current_folder, '*.png'));
    
    png_filenames = {png_files.name};  
    
    for i = 1:length(jpeg_files)
        jpeg_filename = fullfile(current_folder, jpeg_files(i).name);
        
        [~, name, ~] = fileparts(jpeg_files(i).name);
        png_filename = fullfile(current_folder, [name, '.png']);
        
        if ~ismember([name, '.png'], png_filenames)
            img = imread(jpeg_filename);
            
            imwrite(img, png_filename);
          
            fprintf('Converted %s to %s\n', jpeg_filename, png_filename);
        else
            fprintf('Skipping %s because %s already exists.\n', jpeg_filename, png_filename);
        end
    end
end