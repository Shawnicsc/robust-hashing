clc;clear;
Value_b= 2.5:0.01:3.5;% 控制b的取值
p = cell(size(Value_b));%收敛点

% 给b赋值
for i = 1:length(Value_b)
b = Value_b (i);
%初始化参数
x=0.5;
max_iteration = 10000; %最大迭代次数
iterations_time= 0; %当前迭代轮次
flag = false; %% 收敛标志
% 对周期性的探讨，分两种情况去求解
period=[];
while ~flag && iterations_time < max_iteration
x_next = b * x * (1 - x);

% 检测周期性收敛
if ~isempty(period) && abs(x_next - period)< 1e-6
    p{i} = [p{i},x_next];
    flag = true;

% 检测非周期性收敛
elseif any(abs( [p{i}] - x_next)< 1e-6)
    flag = true;
end
p{i} = [p{i}, x_next];
period = x_next;
x = x_next;
iterations_time = iterations_time + 1;
end
end

% 扩展b的取值范围，获取后续预测图像
extend_b = repelem(Value_b, cellfun(@length, p));
points_flat = cell2mat(p);
plot (extend_b, points_flat, 'b.','Markersize', 1);
xlabel('Value of b');
ylabel('Convergence Point');
title('Convergence Point vs of b');
% 取平均值作为收敛点
data = [Value_b', cellfun(@mean, p)'];
tb1 = array2table(data, 'VariableNames', {'Value of b','ConvergencePoint'});
disp(tb1) % 显示图像
