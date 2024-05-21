function [data] = requestAPI(words)
    % Combine the words into a single query string
    query_string = strjoin(words, '+');
    
    % Create the query URL
    base_url = 'https://www.googleapis.com/books/v1/volumes?q=';
    query_url = [base_url query_string];
    
    % Send the request and read the response
    try
    response = webread(query_url);
    
    % Display the response
    % disp(response);
    try
    data = response.items(1).volumeInfo;
    catch
        data = response.items{1,1}.volumeInfo;
    end
    catch ME
    % Handle errors gracefully
    data = "tokenUnic";
    disp('Problema la request');
    disp(ME.message);
    end
end