classdef app3_exported < matlab.apps.AppBase

    % Properties that correspond to app components 
    properties (Access = public)
        UIFigure                      matlab.ui.Figure
        UploadimageforColorfilterButton  matlab.ui.control.Button
        UploadimageforGaussianButton  matlab.ui.control.Button
        UploadimageforEnhancementButton  matlab.ui.control.Button
        Label                         matlab.ui.control.Label
        UIAxes1_1                     matlab.ui.control.UIAxes
        UIAxes1_2                     matlab.ui.control.UIAxes
        UIAxes1_3                     matlab.ui.control.UIAxes
        UIAxes1_4                     matlab.ui.control.UIAxes
        UIAxes1_5                     matlab.ui.control.UIAxes
        UIAxes1_6                     matlab.ui.control.UIAxes
        UIAxes1_7                     matlab.ui.control.UIAxes
        UIAxes1_8                     matlab.ui.control.UIAxes
        UIAxes1_9                     matlab.ui.control.UIAxes
        UIAxes2_1                     matlab.ui.control.UIAxes
        UIAxes2_2                     matlab.ui.control.UIAxes
        UIAxes2_3                     matlab.ui.control.UIAxes
        UIAxes3_1                     matlab.ui.control.UIAxes
        UIAxes3_2                     matlab.ui.control.UIAxes
    end

    
    methods (Access = private)
        
        % ----------------------------------------------------------------------- %
        %                        C O L O R    F I L T E R                         %
        %                                                                         %
        %  colors of HSV example)                                                 %
        %                         Red : 320 ~ 050                                 %
        %                         Green : 050 ~ 170                               %
        %                         Blue : 170 ~ 305                                %
        % ----------------------------------------------------------------------- %

        function I = colorfilter(app, image, range)

            % RGB to HSV conversion
            I = rgb2hsv(image);         
    
            % Normalization range between 0 and 1
            range = range./360;
    
            % Mask creation
            if(size(range,1) > 1), error('Error. Range matriz has too many rows.'); end
            if(size(range,2) > 2), error('Error. Range matriz has too many columns.'); end

            if(range(1) > range(2))
                % Red hue case
                mask = (I(:,:,1)>range(1) & (I(:,:,1)<=1)) + (I(:,:,1)<range(2) & (I(:,:,1)>=0));
            else
                % Regular case
                mask = (I(:,:,1)>range(1)) & (I(:,:,1)<range(2));
            end
    
            % Saturation is modified according to the mask
            I(:,:,2) = mask .* I(:,:,2);
    
            % HSV to RGB conversion
            I = hsv2rgb(I);
    
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: UploadimageforColorfilterButton
        function UploadimageforColorfilterButtonPushed(app, event)
            global filename;
            global filepath;
            
            [filename, filepath] = uigetfile({'*.png; *.bmp; *.jpg','supported imgaes';...
                                   '*.png', 'Portable Network Graphics(*.png)';...
                                   '*.bmp', 'Bitmap (*.bmp)';...
                                   '*.jpg', 'JPEG(*.jpg)';...
                                   '*.*','All files(*.*)'}, filepath);

            
            % Diverse Gpu image filtering by 이창민, 정원영 for matlab project%

            % Use gpu %
            image = gpuArray(imread([filepath, filename]));
            dimage = im2double(image);
            
            % Sharpened + Equalize %
            gradient = convn(dimage,ones(3)./9,'same') - convn(dimage,ones(5)./25,'same');
            amount = 5;
            sharpened = dimage + amount.*gradient;
            equalized = histeq(dimage);

            % no (R/G/B) series %
            redChannel = dimage(:, :, 1);
            greenChannel = dimage(:, :, 2);
            blueChannel = dimage(:, :, 3);
            nored = cat(3, greenChannel, greenChannel, blueChannel);    % cover from here
            nogreen = cat(3, redChannel, redChannel, blueChannel);
            noblue = cat(3, redChannel, greenChannel, redChannel);      % to here
             

            orf = colorfilter(app,dimage,[320 50]);     % red
            ogf = colorfilter(app, dimage,[50 170]);     % green
            obf = colorfilter(app, dimage,[170 305]);    % blue

            % Output %
            imshow(dimage, 'parent', app.UIAxes1_1);
            imshow(sharpened, 'parent', app.UIAxes1_2);
            imshow(equalized, 'parent', app.UIAxes1_3);
            imshow(nored, 'parent', app.UIAxes1_4);
            imshow(nogreen, 'parent', app.UIAxes1_5);
            imshow(noblue, 'parent', app.UIAxes1_6);
            imshow(orf, [], 'parent', app.UIAxes1_7);
            imshow(ogf, [], 'parent', app.UIAxes1_8);
            imshow(obf, [], 'parent', app.UIAxes1_9);
           
        end

        % Button pushed function: UploadimageforGaussianButton
        function UploadimageforGaussianButtonPushed(app, event)
            global filename;
            global filepath;
            
            [filename, filepath] = uigetfile({'*.png; *.bmp; *.jpg','supported imgaes';...
                                   '*.png', 'Portable Network Graphics(*.png)';...
                                   '*.bmp', 'Bitmap (*.bmp)';...
                                   '*.jpg', 'JPEG(*.jpg)';...
                                   '*.*','All files(*.*)'}, filepath);

            
            % Diverse Gpu image filtering by 이창민, 정원영 for matlab project%

            % Use gpu %
            image = gpuarray(imread([filepath, filename]));
            dimage = im2double(image);
            
            % Gaussian + filtering %
            grayed = mat2gray(image3);
            gau = imnoise(grayed, 'gaussian', 0,0.025);
            filtered = medfilt2(gau);

            adjim = imadjust(dimage);     %Adjust non colored photo%

            

            % Output %
            imshow(imresize(dimage3,1),'parent', app.UIAxes2_1);
            imshow(imresize(adjim,1),'parent', app.UIAxes2_2);
            imshow(imresize(filtered,1),'parent', app.UIAxes2_3); 
          
        end

        % Button pushed function: UploadimageforEnhancementButton
        function UploadimageforEnhancementButtonPushed(app, event)
            global filename;
            global filepath;
            
            [filename, filepath] = uigetfile({'*.png; *.bmp; *.jpg','supported imgaes';...
                                   '*.png', 'Portable Network Graphics(*.png)';...
                                   '*.bmp', 'Bitmap (*.bmp)';...
                                   '*.jpg', 'JPEG(*.jpg)';...
                                   '*.*','All files(*.*)'}, filepath);

            row_img = imread(fullfile(filepath,filename));
            imshow(row_img, 'parent', app.UIAxes);
            
            %image enhancement Model Load%
            load('trainedVDSR-Epoch-100-ScaleFactors-234.mat');
            
            dimage = gpuArray(readimage(img));
            dimage = im2double(dimage);
            [rows,cols,np] = size(dimage);
            Ibicubic = imresize(Ilowres,[rows cols],'bicubic');
            
            Iycbcr = rgb2ycbcr(Ilowres);
            Iy = Iycbcr(:,:,1);
            Icb = Iycbcr(:,:,2);
            Icr = Iycbcr(:,:,3);
            
            Iy_bicubic = imresize(Iy,[rows cols],'bicubic');
            Icb_bicubic = imresize(Icb,[rows cols],'bicubic');
            Icr_bicubic = imresize(Icr,[rows cols],'bicubic');
            
            Iresidual = activations(net,Iy_bicubic,41);
            Iresidual = double(Iresidual);
            
            Isr = Iy_bicubic + Iresidual;
            
            Ivdsr = ycbcr2rgb(cat(3,Isr,Icb_bicubic,Icr_bicubic));
            imshow(Ivdsr,'parent', app.UIAxes3_1)
            imshow(Ivdsr,'parent', app.UIAxes3_2)
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 506 674];
            app.UIFigure.Name = 'MATLAB App';

            % Create UploadimageforColorfilterButton
            app.UploadimageforColorfilterButton = uibutton(app.UIFigure, 'push');
            app.UploadimageforColorfilterButton.ButtonPushedFcn = createCallbackFcn(app, @UploadimageforColorfilterButtonPushed, true);
            app.UploadimageforColorfilterButton.Position = [14 641 163 25];
            app.UploadimageforColorfilterButton.Text = 'Upload image for Color filter';

            % Create UploadimageforGaussianButton
            app.UploadimageforGaussianButton = uibutton(app.UIFigure, 'push');
            app.UploadimageforGaussianButton.ButtonPushedFcn = createCallbackFcn(app, @UploadimageforGaussianButtonPushed, true);
            app.UploadimageforGaussianButton.Position = [14 284 164 22];
            app.UploadimageforGaussianButton.Text = 'Upload image for Gaussian ';

            % Create UploadimageforEnhancementButton
            app.UploadimageforEnhancementButton = uibutton(app.UIFigure, 'push');
            app.UploadimageforEnhancementButton.ButtonPushedFcn = createCallbackFcn(app, @UploadimageforEnhancementButtonPushed, true);
            app.UploadimageforEnhancementButton.Position = [16 135 182 22];
            app.UploadimageforEnhancementButton.Text = 'Upload image for Enhancement';

            % Create Label
            app.Label = uilabel(app.UIFigure);
            app.Label.Position = [-68 273 1 5];

            % Create UIAxes1_1
            app.UIAxes1_1 = uiaxes(app.UIFigure);
            title(app.UIAxes1_1, '원본')
            app.UIAxes1_1.Position = [12 529 133 113];

            % Create UIAxes1_2
            app.UIAxes1_2 = uiaxes(app.UIFigure);
            title(app.UIAxes1_2, 'Sharpened ')
            app.UIAxes1_2.Position = [176 529 133 113];

            % Create UIAxes1_3
            app.UIAxes1_3 = uiaxes(app.UIFigure);
            title(app.UIAxes1_3, 'Equalized')
            app.UIAxes1_3.Position = [353 529 133 113];

            % Create UIAxes1_4
            app.UIAxes1_4 = uiaxes(app.UIFigure);
            title(app.UIAxes1_4, 'Red to Green')
            app.UIAxes1_4.Position = [12 417 133 113];

            % Create UIAxes1_5
            app.UIAxes1_5 = uiaxes(app.UIFigure);
            title(app.UIAxes1_5, 'Green to Red')
            app.UIAxes1_5.Position = [176 417 133 113];

            % Create UIAxes1_6
            app.UIAxes1_6 = uiaxes(app.UIFigure);
            title(app.UIAxes1_6, 'Blue to Red')
            app.UIAxes1_6.Position = [353 417 133 113];

            % Create UIAxes1_7
            app.UIAxes1_7 = uiaxes(app.UIFigure);
            title(app.UIAxes1_7, '(filter)Only Red')
            app.UIAxes1_7.Position = [16 305 133 113];

            % Create UIAxes1_8
            app.UIAxes1_8 = uiaxes(app.UIFigure);
            title(app.UIAxes1_8, '(filter)Only Green')
            app.UIAxes1_8.Position = [176 305 133 113];

            % Create UIAxes1_9
            app.UIAxes1_9 = uiaxes(app.UIFigure);
            title(app.UIAxes1_9, '(filter)Only Blue')
            app.UIAxes1_9.Position = [353 305 133 113];

            % Create UIAxes2_1
            app.UIAxes2_1 = uiaxes(app.UIFigure);
            title(app.UIAxes2_1, '원본')
            app.UIAxes2_1.Position = [12 156 133 113];

            % Create UIAxes2_2
            app.UIAxes2_2 = uiaxes(app.UIFigure);
            title(app.UIAxes2_2, 'Adjusted')
            app.UIAxes2_2.Position = [177 156 133 113];

            % Create UIAxes2_3
            app.UIAxes2_3 = uiaxes(app.UIFigure);
            title(app.UIAxes2_3, 'Gaussian + Filtering')
            app.UIAxes2_3.Position = [353 156 133 113];

            % Create UIAxes3_1
            app.UIAxes3_1 = uiaxes(app.UIFigure);
            title(app.UIAxes3_1, '원본')
            app.UIAxes3_1.Position = [29 11 133 113];

            % Create UIAxes3_2
            app.UIAxes3_2 = uiaxes(app.UIFigure);
            title(app.UIAxes3_2, 'Deep learning Enhancement')
            app.UIAxes3_2.Position = [197 11 133 113];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app3_exported

            % Create UIFigure and components
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
