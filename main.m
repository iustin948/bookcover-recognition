img = imread("cover.jpg");
grey = rgb2gray(img);
%edge = edge(grey,'Prewitt');
inverted = 255 - grey;
scanner = ocr(inverted);
figure;
imshow(edge)
figure;
imshow(inverted)
% Extract text regions
bboxes = scanner.WordBoundingBoxes;
words = scanner.Words;


% Combine the words into a single query string
query_string = strjoin(words, '+');

% Create the query URL
base_url = 'https://www.googleapis.com/books/v1/volumes?q=';
query_url = [base_url query_string];

% Send the request and read the response
response = webread(query_url);

% Display the response
disp(response);
