function [fastr_rows, fastr_cols] = my_fastr_detector(img, output,...
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
        fastr_rows = [];
        fastr_cols = [];
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

  
    % Harris Corners
    sobel_x = fspecial('sobel');
    sobel_y = sobel_x';
    Ix = imfilter(double(img), sobel_x, 'replicate');
    Iy = imfilter(double(img), sobel_y, 'replicate');
    [rows, cols] = size(img);
    
    k = 0.04
    harris_cornerness = zeros(size(img));

    for r=2:rows-1
        for c= 2:cols -1
            if corner_points(r, c)
                Ix_window = Ix(r-1:r+1, c-1:c+1);
                Iy_window = Iy(r-1:r+1, c-1:c+1);

                Ixx = sum(Ix_window(:).^2);
                Iyy = sum(Iy_window(:).^2);
                Ixy = sum(Ix_window(:) .* Iy_window(:));

                det_M = (Ixx * Iyy) - (Ixy^2);
                trace_M = Ixx + Iyy;
                harris_cornerness(r,c) = det_M - k * (trace_M^2);
            end
        end
    end

    % threshold for fastr points
    harris_threshold = 0.05 * max(harris_cornerness);

    fastr_corners = harris_cornerness > harris_threshold;

    if ~any(fastr_corners(:))
        disp("No FASTR corners detected.");
        return;
    end

    [fastr_rows, fastr_cols] = find(fastr_corners);

    % Non-maximal suppression
    nms_corners = non_maximal_suppression(fastr_rows, fastr_cols,...
        nms_radius, img);

    [fastr_rows, fastr_cols] = find(nms_corners);

    if(save_image)
        fig = figure('Visible', 'off'); 
        imshow(uint8(img)), hold on
        plot(fastr_cols, fastr_rows, 'g+', 'MarkerSize', 5);
        hold off
    
        saveas(fig, output);
    
        close(fig);
    end
end

