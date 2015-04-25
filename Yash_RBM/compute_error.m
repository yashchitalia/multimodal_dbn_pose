function [error] = compute_error(Y, Yest)
% Takes Y and Yest in normalized coordinates and returns error in pixels
% for better understanding.
for i = 1:size(Y, 2)
    if rem(i, 2) == 0
        Y(:, i) = Y(:, i)*90;
        Yest(:, i) = Yest(:, i)*90;
    else
        Y(:, i) = Y(:, i)*60;
        Yest(:, i) = Yest(:, i)*60;
    end
end

N = size(Y, 1)*size(Y, 2);
error = (1/N)*sum(sum((Y-Yest).^2));
end
