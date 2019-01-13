function [ tempTable ] = getTablePosition(screenTemp)
%% ��ȡ̨��������λ��
% ��ȡ�Ĳ����ֱ�Ϊ��
% x ������ڽ�ͼ��ˮƽλ��
% y ������ڽ�ͼ�Ĵ�ֱλ��
% width �����
% hight ���߶�
% �洢λ�ã�
% �ṹ�� ��Table 

%% ͼ��Ԥ����
% RGB to HSV
screenTemp_hsv = rgb2hsv(screenTemp);
screenTemp_h = screenTemp_hsv(:,:,1); % hue ɫ�� 0-1 0-360
%screenTemp_s = screenTemp_hsv(:,:,2); % Saturation ���Ͷ� 0-1 0-100��%��
%screenTemp_v = screenTemp_hsv(:,:,3); % Value ���� 0-1 0-255

% hue��ɫ�ȣ�����������ɫ h ֵΪ��һ��ֵ������һ��ӳ�䵽 0-360 ��
screenTemp_h = screenTemp_h * 360;

% ��ֵͨ�� histogram() ���Թ۲쵽ռ��������ɫ��Χ��[159 165]
% figure, histogram(screenTemp_h);

% ��ֵ������ֵ[159 165]
screenTemp_greentable = (screenTemp_h <= 165) & (screenTemp_h >= 159);
% figure, imagesc(screenTemp_greentable);

%% �����⣬��Ե��⡢����任���߶���ȡ
% ��Ϊ����任���ͼ���ڵ����е����ɨ��
% ��ʵ�ĵ�ͼ�ζ��������ļ����û�����á������Ǹ���
% ���Ա����Ƚ���Եʶ�����������Ա�Ե���л���任
% ����Ҳ���С��������
%������Ҫ�Ļ�����Ϊ����任�����ʾ����˱�������������

% ��Ե���
screenTemp_greentable_edge = edge(screenTemp_greentable,'Canny');
% figure, imagesc(screenTemp_greentable_edge);

% ����任
[H,T,R] = hough(screenTemp_greentable_edge);
% figure, imagesc(H);

% ȥ�����з� ˮƽ(1)����ֱ(91)�Ľ��,���Ϊ 0 
tempSize = size(H);
tempMaxDistance = tempSize(1);
tempMaxAngle = tempSize(2);
tempZeros = zeros(tempMaxDistance, 1);
for cow = 1:tempMaxAngle+1
   if cow ~= 1 && cow ~= 91
      H(:, cow) = tempZeros; 
   end
end
% figure, imagesc(H);

% ��ȡ���㣬�����߶εľ���
P = houghpeaks(H, 4);
lines = houghlines(screenTemp_greentable_edge,T,R,P);

tempX1 = zeros(1, length(lines)); % ��ȡ��������
tempY1 = zeros(1, length(lines));
tempX2 = zeros(1, length(lines));
tempY2 = zeros(1, length(lines));

for index = 1:length(lines)
   tempX1(index) = lines(index).point1(1);
   tempY1(index) = lines(index).point1(2);
   tempX2(index) = lines(index).point2(1);
   tempY2(index) = lines(index).point2(2);
end

tempX_max = max([tempX1, tempX2]);
tempX_min = min([tempX1, tempX2]);
tempY_max = max([tempY1, tempY2]);
tempY_min = min([tempY1, tempY2]);

% д�� tempTable ����ķ�Χ
tempTable.x = tempX_min;
tempTable.y = tempY_min;
tempTable.width = tempX_max - tempX_min;
tempTable.hight = tempY_max - tempY_min;

% ���������õ�������Χ��
% figure, imshow(screenTemp);
% rectangle('Position',[tempTable.x, tempTable.y, tempTable.width, tempTable.hight],...
%            'EdgeColor','b',...
%           'LineWidth',1);

end




