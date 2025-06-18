function nms_corners = non_maximal_suppression(corner_rows, corner_cols,...
    supp_radius, img)
    nms_corners = false(size(img)); 
    
    for i = 1:length(corner_rows)
        row_curr = corner_rows(i);
        col_curr = corner_cols(i);

        % Define neighborhood boundaries
        row_start = max(1, row_curr - supp_radius);
        row_end = min(size(img, 1), row_curr + supp_radius);
        col_start = max(1, col_curr - supp_radius);
        col_end = min(size(img, 2), col_curr + supp_radius);

        % Extract neighborhood around the corner
        neighborhood = img(row_start:row_end, col_start:col_end);

        % Check if the current corner is the local maximum
        if img(row_curr, col_curr) == max(neighborhood(:))
            nms_corners(row_curr, col_curr) = true;
        end
    end
end