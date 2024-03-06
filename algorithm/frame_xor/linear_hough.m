function linear_hough(processed, img)    
    % img = imread("tennis.jpg");
    
    % gray = rgb2gray(img);
    % 
    % sobel = edge(gray);

    sobel = processed;
    
    [rows, columns] = size(sobel);
    
    row_accumulator = zeros(columns, 1);
    column_accumulator = zeros(rows, 1);
    
    for row = 1:rows
        for column = 1:columns
            pixel = sobel(row, column);
            if pixel == 1
                disp(string(row) + " " + string(column))
                next_column = column + 1;
                next_pixel = sobel(row, next_column);
                while next_pixel == 0 && next_column < columns
                    next_column = next_column + 1;
                    next_pixel = sobel(row, next_column);
                end
    
                if next_pixel == 1
                    centroid_x = (column + next_column)/2;
                    row_accumulator(round(centroid_x)) = row_accumulator(round(centroid_x)) + 1;
                end
            end
        end
    end
    
    figure
    plot(row_accumulator)
    
    for column = 1:columns
        for row = 1:rows
            pixel = sobel(row, column);
            if pixel == 1
                disp(string(row) + " " + string(column))
                next_row = row + 1;
                next_pixel = sobel(next_row, column);
                while next_pixel == 0 && next_row < rows
                    next_row = next_row + 1;
                    next_pixel = sobel(next_row, column);
                end
    
                if next_pixel == 1
                    centroid_y = (row + next_row)/2;
                    column_accumulator(round(centroid_y)) = column_accumulator(round(centroid_y)) + 1;
                end
            end
        end
    end
    
    figure
    plot(column_accumulator)
    
    
    
    [val, I] = max(row_accumulator);
    x = I;
    
    [val, I] = max(column_accumulator);
    y = I;
    
    range = [1 50];
    radii = zeros(range(2)-range(1), 1);
    
    for row = 1:rows
        for column = 1:column
            pixel = sobel(row, column);
            if pixel == 1
                distance = round(sqrt((column-x)^2 + (row-y)^2));
                if distance >= range(1) && distance <= range(2)
                    idx = round(distance  - range(1)) + 1;
                    radii(idx) = radii(idx) + 1;
                end
            end
        end
    end
    
    figure
    plot(radii)
    
    [val, idx] = max(radii);
    radius = idx + range(1);
    
    figure
    imshow(img);
    viscircles([x y], radius);
end