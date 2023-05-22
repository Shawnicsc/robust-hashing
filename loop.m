clc;clear;
figure('NumberTitle', 'off', 'Name', '图片相似度比较');
%设置 tau 值 进行测试
tau = 0.225;
%控制 变量
key = 1;
Hashlen = 1000;

% 获取测试集中图片路径
imgPath = dir('D:/matlab/Test/DogsVsCats_dogs-vs-cats-redux-kernels-edition/test/small/*');
imgPath = imgPath(~[imgPath.isdir]);
imgList = fullfile({imgPath.folder}.', {imgPath.name}.');
% 设置一个比较的基准图
I1 = imread('D:/matlab/Test/DogsVsCats_dogs-vs-cats-redux-kernels-edition/test/small/1.bmp');
subplot(4,ceil(length(imgList)/4),1);imshow(I1);title('基准图');
% 循环比较 并输出结果
for i = 2:length(imgList)
    I2 = imread(imgList{i});
    res = imgHashSimilar(I1,I2,tau,key,Hashlen);
    disp(imgList{i})
    subplot(4,ceil(length(imgList)/4),i);
    imshow(I2);
    title(res);
end
