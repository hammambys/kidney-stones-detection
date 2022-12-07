function kidney()
    clc
    clear all
    close all
    warning off
    %[filename, pathname]=uigetfile('*.*', 'Pick a MATLAB code file');
    %filename=strcat(pathname,filename);
    %original=imread(filename);
    original=imread('stone2.jpg');
    
    imshow(original);
    title('original');

    b=rgb2gray(original);
    figure;
    imshow(b);
    title('grayscale');

    impixelinfo;
    area=b>20;
    figure;
    imshow(area);
    title('get area of interest');
    
    se = strel('disk',2);
    eroded = imerode(area,se);
    figure;
    imshow(eroded);
    title('erode the image');
    

    mask=imfill(eroded,'holes');
    figure;
    imshow(mask);
    title('get mask of area');
    
    
    e=bwareaopen(mask,1000); % remove objects that are smaller than 1000 pixels
    figure;
    imshow(e);
    title('remove small objects from masked image');

    PreprocessedImage=uint8(double(original).*repmat(e,[1 1 3]));
    figure;
    imshow(PreprocessedImage);
    title('apply mask to image');
    
    
    PreprocessedImage=imadjust(PreprocessedImage,[0.3 0.7],[])+50;
    figure;
    imshow(PreprocessedImage);
    title('Adjust the contrast of the image with contrast limits');

    uo=rgb2gray(PreprocessedImage);
    figure;
    imshow(uo);
    title('reconvert image to grayscale');

    mo=medfilt2(uo,[5 5]);
    figure;
    imshow(mo);
    title('apply median filter');

    po=mo>250;
    figure;
    imshow(po);
    title('get white areas only');
    
    % Remove objects greater than m pixels in area from image I.
    stones = po - bwareaopen(po, 200); %remove object bigger than 200 pixels
    figure;
    imshow(stones);
    title('remove big objects');
    
    

    
% refernce : https://www.mifratech.com/public/blog-page/KIDNEY+STONE+DETECTION+USING+MATLAB+AND+image+processing#:~:text=The%20median%20filter%20is%20used,sensitivity%20using%20Matlab%20simulation%20tool