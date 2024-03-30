img = imread("bookcover.jpg");
grey = rgb2gray(img);
edge = edge(grey,'Prewitt');
inverted = 255 - grey;
scanner = ocr(inverted);
imshow(grey)
imshow(inverted)
% Extract text regions
bboxes = scanner.WordBoundingBoxes;
words = scanner.Words;

% Assuming title is the largest text region
[maxArea, maxIndex] = max([bboxes(:,3) .* bboxes(:,4)]);
title_bbox = bboxes(maxIndex, :);
title_text = words{maxIndex};

disp("Title: " + title_text);