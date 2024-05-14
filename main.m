img = imread("cover.jpg");
grey = rgb2gray(img);
%edge = edge(grey,'Prewitt');
inverted = 255 - grey;
scanner = ocr(inverted);
figure;
imshow(inverted)
% Extract text regions
bboxes = scanner.WordBoundingBoxes;
words = scanner.Words;

%% api request
% Combine the words into a single query string
query_string = strjoin(words, '+');

% Create the query URL
base_url = 'https://www.googleapis.com/books/v1/volumes?q=';
query_url = [base_url query_string];

% Send the request and read the response
response = webread(query_url);

% Display the response
disp(response);
data = response.items(1).volumeInfo;

%% achizitie de imagini
vid = videoinput('winvideo', 1);
vid.FramesPerTrigger = 1;
vid.ReturnedColorspace = 'rgb';
triggerconfig(vid, 'manual');


% Continuous capture loop with error handling
% try
    for k = 1:10000
        % Manually trigger the capture
        start(vid);
        trigger(vid); 

        % Get the captured frame
        img = getdata(vid);
        


        % Display the captured image
        imshow(img);
        drawnow; % Update the figure window

        % Pause for a short time to control the frame rate
        pause(0.1); % Adjust this value to control the frame rate
    end
% catch ME
%     % Handle errors gracefully
%     disp('An error occurred:');
%     disp(ME.message);
% end

% Stop the video input object
stop(vid);

% Clean up
delete(vid);
clear vid;
