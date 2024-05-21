classdef OCRApp < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = private)
        UIFigure            matlab.ui.Figure
        LoadImageButton     matlab.ui.control.Button
        RunOCRButton        matlab.ui.control.Button
        ImageAxes           matlab.ui.control.UIAxes
        OCRResultTextArea   matlab.ui.control.TextArea
        Image               % Store the loaded image
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: LoadImageButton
        function LoadImageButtonPushed(app, ~)
            [filename, pathname] = uigetfile({'*.jpg';'*.png'}, 'Select an image file');
            if isequal(filename,0) || isequal(pathname,0)
                return; % User canceled the operation
            else
                app.Image = imread(fullfile(pathname, filename));
                imshow(app.Image, 'Parent', app.ImageAxes);
            end
        end

        % Button pushed function: RunOCRButton
        function RunOCRButtonPushed(app, ~)
            if isempty(app.Image)
                msgbox('Please load an image first.', 'Error', 'error');
                return;
            end
            
            grey = rgb2gray(app.Image);
            inverted = 255 - grey;
            scanner = ocr(inverted);
            bboxes = scanner.WordBoundingBoxes;
            words = scanner.Words;
            query_string = strjoin(words, '+');
            base_url = 'https://www.googleapis.com/books/v1/volumes?q=';
            query_url = [base_url query_string];
            response = webread(query_url);
            
            % Display OCR results
            app.OCRResultTextArea.Value = response.items(1).volumeInfo.title;
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)
            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'OCRApp';

            % Create LoadImageButton
            app.LoadImageButton = uibutton(app.UIFigure, 'push');
            app.LoadImageButton.ButtonPushedFcn = createCallbackFcn(app, @LoadImageButtonPushed, true);
            app.LoadImageButton.Position = [22 422 100 22];
            app.LoadImageButton.Text = 'Load Image';

            % Create RunOCRButton
            app.RunOCRButton = uibutton(app.UIFigure, 'push');
            app.RunOCRButton.ButtonPushedFcn = createCallbackFcn(app, @RunOCRButtonPushed, true);
            app.RunOCRButton.Position = [132 422 100 22];
            app.RunOCRButton.Text = 'Run OCR';

            % Create ImageAxes
            app.ImageAxes = uiaxes(app.UIFigure);
            app.ImageAxes.Position = [22 53 300 300];

            % Create OCRResultTextArea
            app.OCRResultTextArea = uitextarea(app.UIFigure);
            app.OCRResultTextArea.Position = [349 22 270 422];
        end
    end

    methods (Access = public)

        % Construct app
        function app = OCRApp
            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end
