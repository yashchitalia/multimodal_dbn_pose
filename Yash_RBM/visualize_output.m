function [] = visualize_output(img_to_plot, targets)
image_trans = [];
image_num = 3;
for i = 1:size(targets, 2)
    if rem(i, 2) == 0
        targets(:, i) = targets(:, i)*90;
    else
        targets(:, i) = targets(:, i)*60;
    end
end
figure;
for i = 1:image_num
    image_trans = reshape(uint8(img_to_plot(i,1:end)*255.0), [60, 90]);
    final_img(:, :, i) = image_trans';
    target_coord(:,:,i) = reshape(targets(i,:), [2, 15]);
end
for k = 1:image_num
subplot(1, size(final_img,3), k)
imshow(final_img(:, :, k))
hold on;
for j = 1:size(target_coord(:,:,k), 2)
    plot(target_coord(1,j,k), target_coord(2,j,k),'r.','MarkerSize',10)
end
end
