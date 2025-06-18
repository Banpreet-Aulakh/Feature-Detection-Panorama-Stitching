function create_panorama4(output, varargin)
    numImages = length(varargin);
    if numImages < 2
        error('At least two images are required to create a panorama.');
    end
    
    gray_images = cell(1, numImages);
    for i = 1:numImages
        gray_images{i} = format_image(varargin{i});
    end
    
    H_cumulative = cell(numImages,1);
    H_cumulative{1} = eye(3);
    
    for i = 2:numImages
        [matched_pts1, matched_pts2] = feature_match(gray_images{i-1}, gray_images{i}, '', "fastr", false);
        
        H = compute_homography(matched_pts1, matched_pts2, 3.0, 60);
        
        H_cumulative{i} = H_cumulative{i-1} * H;
        H_cumulative{i} = H_cumulative{i} / H_cumulative{i}(3,3);
    end
    
    xlim = zeros(numImages,2);
    ylim = zeros(numImages,2);
    for i = 1:numImages
        [height_i, width_i] = size(gray_images{i});
        [xlim(i,:), ylim(i,:)] = outputLimits(projective2d(H_cumulative{i}), [1 width_i], [1 height_i]);
    end
    
    xMin = min(xlim(:));
    xMax = max(xlim(:));
    yMin = min(ylim(:));
    yMax = max(ylim(:));

    width = round(xMax - xMin);
    height = round(yMax - yMin);

    xLimits = [xMin xMax];
    yLimits = [yMin yMax];

    panoramaView = imref2d([height width], xLimits, yLimits);
    
    panorama = [];
    
    for i = 1:numImages
        warpedImage = imwarp(gray_images{i}, projective2d(H_cumulative{i}), 'OutputView', panoramaView);
        mask = imwarp(true(size(gray_images{i})), projective2d(H_cumulative{i}), 'OutputView', panoramaView);
        
        warpedImage = im2double(warpedImage);

        if isempty(panorama)
            panorama = warpedImage;
        else
            panorama = imblend(warpedImage, panorama, mask, Mode="Alpha",...
                ForegroundOpacity=0.9);
        end
    end
    
    panorama_uint8 = im2uint8(panorama);
    
    imwrite(panorama_uint8, output);
    
    fprintf('Panorama saved to %s.\n', output);
end