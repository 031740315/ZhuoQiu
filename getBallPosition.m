
%% ��ȡ�������λ�ã���ʶ���������׼������׼����


%% ͼ����
% ��ȡ hue (ɫ��ͼ)
tempImage = rgb2hsv(Table.outerImage.rgb);
Table.outerImage.h = tempImage(:, :, 1);
% Table.outerImage.s = tempImage(:, :, 2);
% Table.outerImage.v = tempImage(:, :, 3);
% hue��ɫ�ȣ�����������ɫ h ֵΪ��һ��ֵ������һ��ӳ�䵽 0-360 ��
screenTemp_h = Table.outerImage.h * 360;
% ��ֵ������ֵ 160 ����
screenTemp_bw_withHole = (screenTemp_h < 100 | 200 < screenTemp_h);
% ���
screenTemp_bw = imfill(screenTemp_bw_withHole, 'holes');
% ����
% figure, imshow(screenTemp_bw);

%% ȥ���������ĸ���
% �����ɰ棬�ڱߣ�����
tempEdgeWidth = round(Table.sizeMassArea.x - Table.sizeInside.x);
mask = ones(size(screenTemp_bw));
% ���
mask(:, 1:tempEdgeWidth) = 0;
% �ұ�
mask(:, end-tempEdgeWidth:end) = 0;
% �ϱ�
mask(1:tempEdgeWidth, :) = 0;
% �±�
mask(end-tempEdgeWidth:end, :) = 0;
% Ӧ���ɰ�
screenTemp_bw = mask & screenTemp_bw;
% ����ģʽ
% figure, imshow(screenTemp_bw);

%% Բ�μ��
% �ҶȻ�
screenTemp_bw = screenTemp_bw*255;
% ���Բ��
tempRadius = Ball.sizeRadius;
threshold_min = tempRadius - tempRadius * 0.45;
threshold_max = tempRadius + tempRadius * 0.5;
threshold_min = round(threshold_min);
threshold_max = round(threshold_max);
[centers, radius] = imfindcircles(screenTemp_bw, [threshold_min threshold_max], ...
                                      'ObjectPolarity', 'bright', ...
                                      'Method', 'PhaseCode', ...
                                      'Sensitivity', 0.9, ...
                                      'EdgeThreshold',0.09);                              
% ����Բ��
% ����
% tempImage = Table.outerImage.rgb;
% L = size(radius);
% for i = 1:L(1)
%     cx = centers(i,1);
%     cy = centers(i,2);
%     cr = radius(i);
%     %img = insertShape(img, 'circle', [cx cy cr], 'LineWidth',2,'Color','b');
%     tempImage = insertShape(tempImage, 'circle', [cx cy cr], 'LineWidth',2,'Color','blue');
% end
% figure, imshow(tempImage);

%% �ֱ������׼������ͨ����׼����
% ��׼��������������Ϊ��
sampleWidth = 2;
Ball.center.aimRing = [0, 0];
Ball.center.aimRing_index = 0;
Ball.center.aimRing_radius = 0;
for i = 1:length(radius)
    sampleX = centers(i,1);
    sampleY = centers(i,2);
    % ����
    x = round(sampleX - sampleWidth/2);
    y = round(sampleY - sampleWidth/2);
    sampleM = getImageArea(screenTemp_bw_withHole, x, y, sampleWidth, sampleWidth);
    % �Ա�
    if sum(sum(sampleM)) < 4
        Ball.center.aimRing = [sampleX, sampleY];
        Ball.center.aimRing_index = i;
        Ball.center.aimRing_radius = radius(i);
        break
    end
end

% ��������������׼��֮�������ߣ�ͬʱ����һ�¾��룬����Ŀ����
sampleWidth = 4;
Ball.center.whiteBall = [0, 0];
Ball.center.whiteBall_index = 0;
Ball.center.whiteBall_radius = 0;
for i = 1:length(radius)
    % ������׼��
    if Ball.center.aimRing_index == i
       continue 
    end
    % �����߶ε���������
    sampleX = (centers(i,1) + Ball.center.aimRing(1)) / 2;
    sampleY = (centers(i,2) + Ball.center.aimRing(2)) / 2;
    % ��������������ľ��룬�����ٽ�����
    dx = centers(i,1) - Ball.center.aimRing(1);
    dy = centers(i,2) - Ball.center.aimRing(2);
    distance = sqrt(dx^2 + dy^2);
    K = distance/Ball.sizeDiameter; % ��һ��
    if 0.7 < K && K < 1.5
        continue;
    end
    % ����
    x = round(sampleX - sampleWidth/2);
    y = round(sampleY - sampleWidth/2);
    sampleM = getImageArea(screenTemp_bw_withHole, x, y, sampleWidth, sampleWidth);
    % �Ա�
    if sum(sum(sampleM)) > 4
        Ball.center.whiteBall = [centers(i,1), centers(i,2)];
        Ball.center.whiteBall_index = i;
        Ball.center.whiteBall_radius = radius(i);
        break
    end
end

% ��׼��������������׼�����ӽ����ֱ��
Ball.center.targetBall = [0, 0];
Ball.center.targetBall_index = 0;
Ball.center.targetBall_radius = 0;
for i = 1:length(radius)
    % ������׼��
    if Ball.center.aimRing_index == i
       continue 
    end
    % ��������
    if Ball.center.whiteBall_index == i
       continue 
    end
    % �������ľ���
    sampleX = centers(i,1);
    sampleY = centers(i,2);
    dx = sampleX - Ball.center.aimRing(1);
    dy = sampleY - Ball.center.aimRing(2);
    distance = sqrt(dx^2 + dy^2);
    K = distance/Ball.sizeDiameter; % ��һ��
    % �Ա�
    if 0.8 < K && K < 1.2
        Ball.center.targetBall = [centers(i,1), centers(i,2)];
        Ball.center.targetBall_index = i;
        Ball.center.targetBall_radius = radius(i);
        break
    end
end

% ��ͨ���ų����ϵĲ�����Ϊ��ͨ��

Ball.center.normalBall = [];
Ball.center.normalBall_radius = [];
for i = 1:length(radius)
    % ������׼��
    if Ball.center.aimRing_index == i
       continue 
    end
    % ��������
    if Ball.center.whiteBall_index == i
       continue 
    end
    % ����Ŀ����
    if Ball.center.targetBall_index == i
       continue 
    end
    % ��ӽ� ��ͨ��
    Ball.center.normalBall = [Ball.center.normalBall; [centers(i,1), centers(i,2)]];
    Ball.center.normalBall_radius = [Ball.center.normalBall_radius, radius(i)];
end


