%%
clear;
clc;

%% 导入数据
data1 = readtable('data1.xlsx');
newColumnNames = {'device', 'lon', 'lat', 'height', 'time'};
data1.Properties.VariableNames(1:5) = newColumnNames;

disp(data1(1:5,:));


% 指定要保留的行
deviceValuesToKeep = {'B', 'D', 'F', 'G'}; % 设备值为需要保留的值
idx = ismember(data1.device, deviceValuesToKeep);

% 保留指定行的列
data1 = data1(idx, :);

%% 数据转换
data1.X_km = (data1.lon - 110.241) * 97.304;
data1.Y_km = (data1.lat - 27.204) * 111.263;
data1.Z_km = data1.height / 1000;
data1.R_km = data1.time * 340 / 1000;

disp(data1(:, {'X_km', 'Y_km', 'Z_km', 'R_km'}));

%% 定义范围
bounds = [-100 100; -100 100; 0 10; -100 500];

%% 优化求解
options = optimoptions('particleswarm', 'Display', 'iter');
[result, fval, exitflag, output] = particleswarm(@(params) objective_function(params, data1), 4, bounds(:,1), bounds(:,2), options);

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

    for index = 1:size(data1, 1)
        actual_distance = sqrt((x - data1.X_km(index))^2 + (y - data1.Y_km(index))^2 + (z - data1.Z_km(index))^2);
        target_distance = data1.R_km(index) + c;
        point = data1.device{index};

        disp(['相对观测点', point, '的距离差为: ', num2str(actual_distance - target_distance), ' km']);
    end
else
    fprintf('Optimization failed: %s\n', output.message);
end


% 目标函数
function total_diff = objective_function(params, data)
    x = params(1);
    y = params(2);
    z = params(3);
    c = params(4);
    total_diff = 0;
    for idx = 1:height(data)
        target_distance = data.R_km(idx) + c;
        actual_distance = sqrt((x - data.X_km(idx))^2 + (y - data.Y_km(idx))^2 + (z - data.Z_km(idx))^2);
        difference = abs(actual_distance - target_distance);
        total_diff = total_diff + difference;
    end
    total_diff = total_diff / height(data);
end