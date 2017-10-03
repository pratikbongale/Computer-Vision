function Homography(fn)

INTERACTIVE = true;

    % Add path
    addpath( [ '..' filesep() 'TEST_IMAGES' filesep() ] );
    addpath( [ '..' filesep() '..' filesep() 'TEST_IMAGES' filesep() ] );
    
    % default image
    if nargin < 1
        fn = 'IMG_5802.jpg';
    end
           
    im_rgb = im2double(imread(fn));
    
    % select 4 points from the given image the represents the region of interest
    figure;
    imshow(im_rgb);
    title('Please select 4 points on the board corners');
    
    if INTERACTIVE
        % select points in Clockwise order
        [u v] = ginput(4);
        u = round(u);
        v = round(v);
        save input_points_data;
    else
        load input_points_data;
    end
    
    % specify 4 ideal positions we want to see these selected points in.
    x = zeros(4);
    y = zeros(4);
    
    x = [u(1); u(2); u(3); u(4)];   % x co-ordinates remain unchanged
    y = [v(1)-5; v(1)-5; v(4)+5; v(4)+5];   % make it a rectangle surrounding the original board
    
    input_pts = [u v];          % points in input image
    reference_pts = [x y];      % base points we want our image to be transformed into 
    
    H = fitgeotrans(input_pts, reference_pts, 'projective');   % perform projective transform
    
    out_img = imwarp( im_rgb, H ); % warp the image with specified transform matrix
    figure; 
    imshow(out_img);
    title('Output after homography');

end