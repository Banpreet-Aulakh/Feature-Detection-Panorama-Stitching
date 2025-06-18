convert_all_to_png();
rng(0); 
img1 = format_image("S1-im1.png");
img2 = format_image("S1-im2.png");

img3 = format_image("S2-im1.png");
img4 = format_image("S2-im2.png");
img5 = format_image("S2-im3.png");
img6 = format_image("S2-im4.png");
% S3-Data Credit: 
% https://www.kaggle.com/datasets/deepzsenu/images-data?resource=download
img7 = format_image("S3-im1.png");
img8 = format_image("S3-im2.png");
img9 = format_image("S3-im3.png");
img10 = format_image("S3-im4.png");

img11 = format_image("S4-im1.png");
img12 = format_image("S4-im2.png");


[fast_rows1, fast_cols1] = my_fast_detector(img1, "S1-fast.png", true, 3.0);
[fastr_rows1, fastr_cols1] = my_fastr_detector(img1, "S1-fastR.png", true, 3.0);
 
[fast_rows3, fast_cols3] = my_fast_detector(img3, "S2-fast.png", true, 3.0);
[fastr_rows3, fastr_cols3] = my_fastr_detector(img3, "S2-fastR.png", true, 3.0);

fast_tester(img1, 10);
fast_tester(img3, 10);

[fast_matched1, fast_matched1_2] = ...
    feature_match(img1, img2, "S1-fastMatch.png", "fast", true);

[fastr_matched1, fastr_matched1_2]= ... 
    feature_match(img1, img2, "S1-fastRMatch.png", "fastR", true);

[fast_matched2, fast_matched2_2] = ...
    feature_match(img3, img4, "S2-fastMatch.png", "fast", true);

[fastr_matched2, fastr_matched2_2]= ... 
    feature_match(img3, img4, "S2-fastRMatch.png", "fastR", true);

create_panorama4("S1-panorama.png", "S1-im1.png", "S1-im2.png");
create_panorama4("S2-panorama.png", "S2-im1.png", "S2-im2.png", "S2-im3.png", "S2-im4.png");
create_panorama4("S3-panorama.png", "S3-im1.png", "S3-im2.png", "S3-im3.png", "S3-im4.png");
create_panorama4("S4-panorama.png", "S4-im1.png", "S4-im2.png");
