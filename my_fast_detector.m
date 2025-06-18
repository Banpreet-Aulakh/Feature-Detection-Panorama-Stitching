function [corner_rows, corner_cols] = my_fast_detector(img, output,...
    save_image, nms_radius)
    t = 50;
    N=12;
    [rows, cols] = size(img);

    % high speed test
    I1 = circshift(img, [-3, 0]);
    I5 = circshift(img, [0, 3]);
    I9 = circshift(img, [3, 0]);
    I13 = circshift(img, [0, -3]);

    cond1 = (I1 > img + t) + (I5 > img + t) + (I9 > img + t) + (I13 > img + t);
    cond2 = (I1 < img - t) + (I5 < img - t) + (I9 < img - t) + (I13 < img - t);
    
    candidates = (cond1 >= 3) | (cond2 >= 3);
    
    if ~any(candidates(:))
        disp("No FAST corners detected");
        corner_rows = [];
        corner_cols = [];
        return;
    end

    % remaining 16 pixel test
    circle_offsets = [-3, 0; -3, 1; -2, 2; -1, 3;
        0, 3; 1, 3;2, 2; 3, 1;
        3, 0; 3, -1; 2, -2; 1, -3;
        0, -3; -1, -3; -2, -2; -3, -1];

    shifted_imgs = zeros(rows, cols, 16);
    for i = 1:16
        shifted_imgs(:,:,i) = circshift(img, circle_offsets(i, :));
    end

    central_pixel = repmat(img, [1,1,16]);

    brighter = shifted_imgs > (central_pixel + t);
    darker = shifted_imgs < (central_pixel - t);

    num_pixels = rows * cols;
    brighter_reshaped = reshape(brighter, num_pixels, 16);
    darker_reshaped = reshape(darker, num_pixels, 16);
    candidates_reshaped = reshape(candidates, num_pixels, 1);

    brighter_extended = [brighter_reshaped, brighter_reshaped(:, 1:N-1)];
    darker_extended = [darker_reshaped, darker_reshaped(:, 1:N-1)];

    conv_filter = ones(1,N);

    sums_brighter = conv2(brighter_extended, conv_filter, "valid");
    sums_darker = conv2(darker_extended, conv_filter, "valid");
    
    brighter_corner = any(sums_brighter >= N, 2);
    darker_corner = any(sums_darker >= N, 2);

    corner_pixels = (brighter_corner | darker_corner) & candidates_reshaped;

    corner_points = reshape(corner_pixels, rows, cols);

    [corner_rows, corner_cols] = find(corner_points);
    
    % Non-maximal suppression
    nms_corners = non_maximal_suppression(corner_rows, corner_cols,...
        nms_radius, img);

    [corner_rows, corner_cols] = find(nms_corners);
    
    if(save_image)
        fig = figure('Visible', 'off'); 
        imshow(uint8(img)), hold on
        plot(corner_cols, corner_rows, 'r+', 'MarkerSize', 5);
        hold off
    
        saveas(fig, output);
        close(fig);
    end
end


        
    
    