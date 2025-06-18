function img = format_image(image)
    img = imread(image);

    if(size(img, 3) == 3)
        img = rgb2gray(img);
    end

    [rows, cols]  = size(img);
    
    if rows > cols
        img = imresize(img, [750 NaN]);
    else
        img = imresize(img, [NaN 750]);
    end

    if ~isa(img, 'uint8')
        img = im2uint8(img);
    end
end