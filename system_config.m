
%% ��ʾ���ߴ�,�Զ���ȡ
tempArray = getMonitorSize();
Monitor = struct; % ����һ���ṹ��
Monitor.width = tempArray(3);
Monitor.hight = tempArray(4);

%% ����
Table = struct;
% ��ȡ������Ļ�����Ͻǡ��ķ�֮һ
screenTemp = screenShoot([0, 0, Monitor.width/2, Monitor.hight/2 + 20]);
% ��ȡ�ⲿ�ߴ�
Table.sizeOuter = getTablePosition(screenTemp);
% ����
% figure, imshow(screenTemp);
% rectangle('Position',[Table.sizeOuter.x, Table.sizeOuter.y, Table.sizeOuter.width, Table.sizeOuter.hight],...
%           'EdgeColor','r',...
%           'LineWidth',2);


% �����ڲ��ߴ�
tempWidth = Table.sizeOuter.width / 60; % ���ݱ�������ߵĿ��
Table.sizeInside.x = Table.sizeOuter.x + tempWidth;
Table.sizeInside.y = Table.sizeOuter.y + tempWidth;
Table.sizeInside.width = Table.sizeOuter.width - tempWidth * 2;
Table.sizeInside.hight = Table.sizeOuter.hight - tempWidth * 2;
% ����
% figure, imshow(screenTemp);
% rectangle('Position',[Table.sizeInside.x, Table.sizeInside.y, Table.sizeInside.width, Table.sizeInside.hight],...
%           'EdgeColor','g',...
%           'LineWidth',2);

% ���������˶��ķ�Χ
tempRadius = Table.sizeOuter.width / 32 / 2; % ���ݱ�������ߵİ뾶
Table.sizeMassArea.x =  Table.sizeInside.x + tempRadius;
Table.sizeMassArea.y =  Table.sizeInside.y + tempRadius;
Table.sizeMassArea.width =  Table.sizeInside.width - tempRadius * 2;
Table.sizeMassArea.hight =  Table.sizeInside.hight - tempRadius * 2;
% ����ģʽ
% figure, imshow(screenTemp);
% rectangle('Position',[Table.sizeMassArea.x, Table.sizeMassArea.y, Table.sizeMassArea.width, Table.sizeMassArea.hight],...
%           'EdgeColor','b',...
%           'LineWidth',2);

%% ��
Ball.sizeDiameter = Table.sizeOuter.width / 32; % ���ݱ����������ֱ��
Ball.sizeRadius = Ball.sizeDiameter / 2;



