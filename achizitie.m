function [data] = achizitie(vid)

    start(vid);
    
    % Loop to capture a frame every second
    while islogging(vid)
        pause(1); % Wait for 1 second
        img = getsnapshot(vid); % Get a frame
        words = scanareCoperta(img);
        words
        data = requestAPI(words);  
        pause(0.1); % Adjust this value to control the frame rate
    end

end