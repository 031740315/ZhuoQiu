function [tempImage] = getImageArea(inputImage, x, y, w, h)
%% ��ȡͼƬ�Ĳ�������
tempImage = inputImage(y:y+h, x:x+w, :);
end