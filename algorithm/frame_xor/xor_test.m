base_l = imread("no_tennis_l.jpg");
base_r = imread("no_tennis_r.jpg");

g_l = toGray(base_l);
g_r = toGray(base_r);

[rows, columns] = size(g_l);

% base_diff = takeDiff(g_l, g_r, rows, columns);


% imshow(base_diff)

img_l = toGray(imread("tennis_l_2.jpg"));
img_r = toGray(imread("tennis_r_2.jpg"));

% img_diff = takeDiff(img_l, img_r, rows, columns);

% figure
% imshow(img_diff)

% ball_diff = takeDiff(base_diff, img_diff, rows, columns);
% figure
% imshow(ball)

diff_l = takeDiff(g_l, img_l, rows, columns);
diff_r = takeDiff(g_r, img_r, rows, columns);

linear_hough(diff_l > 20, img_l);
linear_hough(diff_r > 20, img_r);

% for row = 1:rows
%     for column = 1:columns
%         if diff_l(row, column) > 2
%             disp("Row: " + string(row) + " Column : " + string(column))
%         end
%     end
% end
% 
% figure
% imshowlimited(diff_l, 20);
% figure
% imshow((img_l));
% figure
% imshowlimited(diff_r, 20);
% figure
% imshow((img_r));


function results = toGray(img)
    results = rgb2gray(img);
end

function results = takeDiff(left, right, rows, columns)
    diff = zeros(rows, columns);

    for row = 1:rows
        for column =  1:columns
            % diff(row, column) = bitxor(left(row, column), right(row, column), 'uint8');
            diff(row, column) = abs(left(row, column) - right(row, column));
        end
    end

    results = diff;
end

function imshowlimited(img, thresh)
    imshow(img > thresh);
end