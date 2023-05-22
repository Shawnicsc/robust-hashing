function res = imgHashSimilar(I1,I2,tau,key,Hashlen)
% 对图片进行灰度转化
I1 = im2gray(I1); 
I2 = im2gray(I2);
% 修改图片尺寸为64*64的标准化图
I1 = imresize(I1,[64,64]);
I2 = imresize(I2,[64,64]);
% 划分成8*8子块，进行二维离散余弦变换
fun = @dct2;
I1 = blkproc(I1,[8 8],fun);
I2 = blkproc(I2,[8 8],fun);
% DC系数，（1,1）置为0
I1(1,1) = 0;
I2(1,1) = 0;
% 通过密钥伪随机生成Hashlen个服从标准正态64*64矩阵
randn('state',key);
N = cell(1,Hashlen);
% 高斯低通滤波器进行迭代滤波
K = fspecial('gaussian');
Y = cell(1,Hashlen);

for i = 1:Hashlen
    N{i} = randn(64);
    Y{i} = filter2(K,N{i});
end
% DCT敏感度矩阵m,周期延拓至64*64
m = [
71.43 99.01 86.21 60.24 41.67 29.16 20.88 15.24;
99.01 68.97 75.76 65.79 50.00 36.90 27.25 20.28;
86.21 75.76 44.64 38.61 33.56 27.47 21.74 17.01;
60.24 65.79 38.61 26.53 21.98 18.87 15.92 13.16;
41.67 50.00 33.56 21.98 16.26 13.14 11.48 9.83;
29.16 36.90 27.47 18.87 13.14 10.40 8.64 7.40;
20.88 27.25 21.74 15.92 11.48 8.64 6.90 5.78;
15.24 20.28 17.01 13.16 9.83 7.40 5.78 4.73];
% 矩阵m进行周期延拓得到大小为64 ×64 的矩阵M
M = repmat(m,8,8);
I1_Hash = ones(1,Hashlen);
I2_Hash = ones(1,Hashlen);
% 对Hashlen个伪随机矩阵遍历计算
for k = 1:Hashlen
    I1_sum = 0;
    I2_sum = 0;
    for i = 1:64
        for j = 1:64
            I1_sum = I1_sum + I1(i,j) * Y{k}(i,j) * M(i,j);
            I2_sum = I2_sum + I2(i,j) * Y{k}(i,j) * M(i,j);
        end
    end
    if I1_sum < 0
        I1_Hash(k) = 0;
    end
    if I2_sum < 0
        I2_Hash(k) = 0;
    end
end
% 汉明距离计算
dis = norm((I1_Hash-I2_Hash)/(2*sqrt(norm(I1_Hash)*norm(I2_Hash))));
% 与阈值比较
if tau < dis
    res = '不相似';
else
    res = '相似';
end
