function [matched_pts1, matched_pts2] = feature_match(im1, im2, output, ...
    detector, save_image)
    if (detector == "fast")
        [rows1, cols1] = my_fast_detector(im1, '', false, 3.0);
        [rows2, cols2] = my_fast_detector(im2, '', false, 3.0);
    else
        [rows1, cols1] = my_fastr_detector(im1, '', false, 3.0);
        [rows2, cols2] = my_fastr_detector(im2, '', false, 3.0);
    end

    % Combine columns and rows into an Nx2 matrix and create ORBPoints
    points1 = ORBPoints([cols1(:), rows1(:)]);
    points2 = ORBPoints([cols2(:), rows2(:)]);

    [features1, valid_pts1] = extractFeatures(im1, points1, "Method", "ORB");
    [features2, valid_pts2] = extractFeatures(im2, points2, "Method","ORB");
    
    index_pairs = matchFeatures(features1, features2, 'MatchThreshold', 100, 'MaxRatio', 0.8);  
    
    
    matched_pts1 = valid_pts1(index_pairs(:, 1));
    matched_pts2 = valid_pts2(index_pairs(:, 2));

    if save_image
        fig = figure("Visible", "off");
        showMatchedFeatures(im1, im2, matched_pts1, matched_pts2, ...
            "montage", "PlotOptions",{'ro', 'g+', 'y-'});
        saveas(fig, output);
        close(fig);
    end
end