% Diverse Gpu image filtering by 이창민, 정원영 for multimedia's matlab project% 


% Use gpu %
image = gpuArray(imread('color.jpg'));
image2 = gpuArray(imread('Autobahnen.jpg'));
image3 = gpuArray(imread('chaplin.png'));
dimage = im2double(image);
dimage2 = im2double(image2);
dimage3 = im2double(image3);

% Gaussian + filtering %
grayed = mat2gray(image3);
gau = imnoise(grayed, 'gaussian', 0,0.025);
filtered = medfilt2(gau);


adjim = imadjust(dimage3);     %Adjust non colored photo%

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

% Color filtering %

orf = colorfilter(dimage,[320 50]);     % red
ogf = colorfilter(dimage,[50 170]);     % green
obf = colorfilter(dimage,[170 305]);    % blue

Aorf = colorfilter(dimage2,[320 50]);     % red
Aogf = colorfilter(dimage2,[50 170]);     % green
Aobf = colorfilter(dimage2,[170 305]);    % blue

% Output %
figure(36824240)
subplot(5, 3, 1); imshow(dimage); title('Original image');
subplot(5, 3, 2); imshow(sharpened); title('sharpened image');
subplot(5, 3, 3); imshow(equalized); title('Equalized');
subplot(5, 3, 4); imshow(nored); title('red to green');
subplot(5, 3, 5); imshow(nogreen); title('green to red');
subplot(5, 3, 6); imshow(noblue); title('blue to red');
subplot(5, 3, 7); imshow(orf, []); title('(filter)only red');
subplot(5, 3, 8); imshow(ogf, []); title('(filter)only green');
subplot(5, 3, 9); imshow(obf, []); title('(filter)only blue');
subplot(5, 3, 10); imshow(Aorf, []); title('Autobahnen red');
subplot(5, 3, 11); imshow(Aogf, []); title('Autobahnen green');
subplot(5, 3, 12); imshow(Aobf, []); title('Autobahnen blue');
subplot(5, 3, 13); imshow(imresize(dimage3,1)); title('Original image');
subplot(5, 3, 14); imshow(imresize(adjim,1)); title('Adjusted');
subplot(5, 3, 15); imshow(imresize(filtered,1)); title('Gaussian + medi2 filter');
suptitle('32153682 이창민 / 32154240 정원영')
