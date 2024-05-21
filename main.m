I = imread("cover.jpg");
  grey = rgb2gray(I);
    inverted = 255 - grey;
    
    scanner = ocr(inverted);
figure 
imshowpair(I,inverted,"montage")
scanner = ocr(BW);
  
    % Extract words from OCR results
    words = scanner.Words
%%
img = imread("cover.jpg");
img  = snapshot(webcam);
 % Convert the image to grayscale
    grey = rgb2gray(img);
   
    ed = edge(grey,"prewitt",0.1);
     imshow(ed);
    % Perform OCR on the processed image
    scanner = ocr(ed);
  
    % Extract words from OCR results
    words = scanner.Words
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
data = response.items{1,1}.volumeInfo;

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

%%
% Find all existing video input objects
vidObjs = imaqfind;

% Delete all existing video input objects
delete(vidObjs);

%%
boundingBoxes = scanner.WordBoundingBoxes;
hold on;

% Iterate through each bounding box
for i = 1:size(boundingBoxes, 1)
    x = boundingBoxes(i, 1);
    y = boundingBoxes(i, 2);
    width = boundingBoxes(i, 3);
    height = boundingBoxes(i, 4);
    
    % Draw empty rectangle
    rectangle('Position', [x, y, width, height], 'EdgeColor', 'red', 'LineWidth', 2);
end

hold off;