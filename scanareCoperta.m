function [words] = scanareCoperta(img)
    grey = rgb2gray(img);
    inverted = 255 - grey;
    
    scanner = ocr(inverted);
    words = scanner.Words;
end