function video_reading( fn_in )

% Get the input video.  For each frame, grab the pixels at column number NNNN over from the left
% And get the pixels from rows 213 to 505.  
%
% Create a "strip image" of all these pixels conncatenated next to each other.
%
    
    addpath( [ '..' filesep() 'TEST_IMAGES' filesep() ] );
    addpath( [ '..' filesep() '..' filesep() 'TEST_IMAGES' filesep() ] );
    
    if nargin < 1
        fn_in = 'TEA_in_TAP_WATER.mov';
%         fn_in = 'videoOut.mp4';
    end

    % display an image for ginput
%     vidObj_properties = VideoReader(fn_in);
%     figure; imagesc( vidObj_properties.readFrame() );   % read first frame
%     title('Please select a point within Beaker');
%     
%     [x y] = ginput(1);
%     column_of_interest = round(x);     % select columns where beaker is present
    
    column_of_interest = 250;

    r1 = 213;
    r2 = 505;
    rows   = r1:r2;     % select rows where beaker is present

    n_frames        = get( VideoReader(fn_in), 'NumberOfFrames' );         
    
    % create video object to read frames from the video file 
    vidObj          = VideoReader(fn_in);    
        
       
    
    % define the output image dimensions
    height          = r2-r1+1;  
    output_im       = uint8( zeros( height, round(n_frames/2), 3 ) );

    k_input_frame   = 1;
    k_out           = 1;
    
    % loop through all frames in video
    while ( (k_input_frame <= n_frames) && (hasFrame(vidObj)) )
        
        if mod( k_input_frame, 100 ) == 1   % print at every 10th frame to show progress
            fprintf('reading in frame %4d\n', k_input_frame);
        end
        
        im          = readFrame(vidObj);    % read a frame to process

        imagesc( im );
        axis image;

        the_pixels  = im( rows, column_of_interest, : );
        output_im( :, k_out, : ) = the_pixels;
        drawnow;

        k_out       = k_out + 1;  
        
            
        % Skipping every other frame:
        if k_input_frame <= n_frames-1
            im      = readFrame(vidObj); % read a frame to skip
        end

        % do some counting here.
        k_input_frame  = k_input_frame + 2;  
        
        
                
    end% read in a frame from the video   

    %
    %  Create a new figure and Display the final strip image here...
    %
    figure('Position', [10 10 1024 768]); imagesc(output_im);
    title('Output image created from streak of images from frames');
    
    %
    %  Write out the final image here... 
    % 
    imwrite(output_im, 'img_strip.jpg' );
end
