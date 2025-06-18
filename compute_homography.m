function [H, inliers] = compute_homography(matched_pts1, matched_pts2, ...
    maxDistance, numTrials)
    pts1 = double(matched_pts1.Location);
    pts2 = double(matched_pts2.Location);

    [tform, inlierIdx] = estimateGeometricTransform2D(pts2, pts1, "projective", ...
        "MaxDistance", maxDistance, "MaxNumTrials", numTrials, ... 
        "Confidence", 99.9);

    H = tform.T;
    inliers = inlierIdx;
    
    fprintf("Found %d inliers out of %d matches.\n", sum(inliers),...
        numel(inliers));

end