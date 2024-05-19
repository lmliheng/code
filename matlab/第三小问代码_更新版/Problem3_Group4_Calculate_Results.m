%%
clear;
clc;

%% 导入数据
data3 = readtable('data3.xlsx');
newColumnNames = {'device', 'lon', 'lat', 'height', 'time1', 'time2', 'time3', 'time4'};
data3.Properties.VariableNames(:) = newColumnNames;

disp(data3(1:5,:));

%% 数据转换
data3.X_km = (data3.lon - 110.241) * 97.304;
data3.Y_km = (data3.lat - 27.204) * 111.263;
data3.Z_km = data3.height / 1000;
data3.R1_km = data3.time1 * 340 / 1000;
data3.R2_km = data3.time2 * 340 / 1000;
data3.R3_km = data3.time3 * 340 / 1000;
data3.R4_km = data3.time4 * 340 / 1000;

disp(data3(:, {'X_km', 'Y_km', 'Z_km', 'R1_km', 'R2_km', 'R3_km', 'R4_km'}));

%%
data_matrix = table2array(data3(:, {'R1_km', 'R2_km', 'R3_km', 'R4_km'}));

result_group2 = [3, 1, 1, 3, 1, 3, 4];

data_array = zeros(1, 7);

for i = 1:7
    data_array(i) = data_matrix(i, result_group2(i));
end


%% 定义范围
bounds = [-100 100; -100 100; 0 30; -100 500];

%% 优化求解
options = optimoptions('particleswarm', 'Display', 'iter');
[result, fval, exitflag, output] = particleswarm(@(params) objective_function(params, data3, data_array), 4, bounds(:,1), bounds(:,2), options);

%% 结果输出
if exitflag > 0
    disp('Optimization successful');
    fitted_point = result;
    fprintf('经度(°): %f\n', fitted_point(1) / 97.304 + 110.241);
    fprintf('纬度(°): %f\n', fitted_point(2) / 111.263 + 27.204);
    fprintf('高程(m): %f\n', fitted_point(3) * 1000);
    fprintf('时间(s): %f\n', fitted_point(4) / 340);

    x = fitted_point(1);
    y = fitted_point(2);
    z = fitted_point(3);
    c = fitted_point(4);

    for index = 1:size(data3, 1)
        actual_distance = sqrt((x - data3.X_km(index))^2 + (y - data3.Y_km(index))^2 + (z - data3.Z_km(index))^2);
        target_distance = data_array(index) + c;
        point = data3.device{index};

        disp(['相对观测点', point, '的距离差为: ', num2str(actual_distance - target_distance), ' km']);
    end
else
    fprintf('Optimization failed: %s\n', output.message);
end


% 目标函数
function total_diff = objective_function(params, data, data_array)
    x = params(1);
    y = params(2);
    z = params(3);
    c = params(4);
    total_diff = 0;
    for idx = 1:height(data)
        target_distance = (data_array(idx) + c)^2;
        actual_distance = (x - data.X_km(idx))^2 + (y - data.Y_km(idx))^2 + (z - data.Z_km(idx))^2;
        difference = abs(actual_distance - target_distance);
        total_diff = total_diff + difference;
    end
    total_diff = total_diff / height(data);
end