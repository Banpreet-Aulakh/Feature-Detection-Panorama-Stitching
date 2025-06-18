function fast_tester(image, attempts)
    total_fast_time = 0;
    total_fastr_time = 0;
    
    num_attempts = attempts;
    
    for i = 1:num_attempts
        fprintf("Running FAST detector (Attempt %d)...\n", i);
        
        tic;
        my_fast_detector(image, '', false, 3.0);
        fast_time = toc;
        total_fast_time = total_fast_time + fast_time;
        
        fprintf("FAST detection took %.4f seconds.\n", fast_time);
        
        fprintf("Running FASTR detector (Attempt %d)...\n", i);
        
        tic;
        my_fastr_detector(image, '', false, 3.0);
        fastr_time = toc;
        total_fastr_time = total_fastr_time + fastr_time;
        
        fprintf("FASTR detection took %.4f seconds.\n", fastr_time);
    end
    
    avg_fast_time = total_fast_time / num_attempts;
    avg_fastr_time = total_fastr_time / num_attempts;
    
    fprintf("\nAverage FAST detection time: %.4f seconds.\n", avg_fast_time);
    fprintf("Average FASTR detection time: %.4f seconds.\n", avg_fastr_time);
end 