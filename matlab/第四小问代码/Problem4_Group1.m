%%
clear;
clc;

%% 导入数据
data4 = readtable('data4.xlsx', 'Sheet', '1');
newColumnNames = {'device', 'lon', 'lat', 'height', 'time1', 'time2', 'time3', 'time4'};
data4.Properties.VariableNames(:) = newColumnNames;

disp(data4(1:5,:));

%% 数据转换
data4.X_km = (data4.lon - 110.241) * 97.304;
data4.Y_km = (data4.lat - 27.204) * 111.263;
data4.Z_km = data4.height / 1000;
data4.R1_km = data4.time1 * 340 / 1000;
data4.R2_km = data4.time2 * 340 / 1000;
data4.R3_km = data4.time3 * 340 / 1000;
data4.R4_km = data4.time4 * 340 / 1000;

disp(data4(:, {'X_km', 'Y_km', 'Z_km', 'R1_km', 'R2_km', 'R3_km', 'R4_km'}));

%%
data_matrix = table2array(data4(:, {'R1_km', 'R2_km', 'R3_km', 'R4_km'}));

%% 定义范围
bounds = [-100 100; -100 100; 0 30; -100 500];

%% 第一步：固定A为1，循环遍历BCD
results = ones(64, 7) * 100;

row = 1;
for i = 1:4
    for j = 1:4
        for k = 1:4
            results(row, 1:3) = [i, j, k];
            row = row + 1;
        end
    end
end

for row = 1:height(results)

    device_combination = [1, results(row, 1:3)];

    for itertime = 1:3
        options = optimoptions('particleswarm', 'Display', 'none');
        [result, fval, exitflag, output] = particleswarm(@(params) objective_function(params, data4, data_matrix, device_combination), 4, bounds(:,1), bounds(:,2), options);
        
        fitted_point = result;
    
        x = fitted_point(1);
        y = fitted_point(2);
        z = fitted_point(3);
        c = fitted_point(4);
        
        result_thistime = zeros(4, 1);
        for index = 1:4
            actual_distance = sqrt((x - data4.X_km(index))^2 + (y - data4.Y_km(index))^2 + (z - data4.Z_km(index))^2);
            target_distance = data_matrix(index, device_combination(index)) + c;
            point = data4.device{index};
            result_thistime(index) = abs(actual_distance - target_distance);
        end
    
        if sum(result_thistime) < sum(results(row, 4:7))
            results(row, 4:7) = result_thistime;
        end
    end

    disp(row)
end

results(:, 8) = sum(results(:, 4:7), 2);
sorted_results = sortrows(results, 8);
%%
disp(['第1组音爆分别对应检测设备A、B、C、D的序号：', num2str([1, sorted_results(1, 1:3)])]);

%% 第二步：明确ABCD分别为1244，作差计算EFG

EFG_matrix = ones(3, 4) * 100;

for itertime = 1:20
    options = optimoptions('particleswarm', 'Display', 'none');
    device_combination = [1, 2, 4, 4];
    [result, fval, exitflag, output] = particleswarm(@(params) objective_function(params, data4, data_matrix, device_combination), 4, bounds(:,1), bounds(:,2), options);
    
    fitted_point = result;
    
    x = fitted_point(1);
    y = fitted_point(2);
    z = fitted_point(3);
    c = fitted_point(4);
    
    
    for index = 5:7
    
        actual_distance = sqrt((x - data4.X_km(index))^2 + (y - data4.Y_km(index))^2 + (z - data4.Z_km(index))^2);
        for col = 1:4
            target_distance = data_matrix(index, col) + c;

            if abs((actual_distance - target_distance)) < abs(EFG_matrix(index-4, col))
                EFG_matrix(index-4, col) = abs(actual_distance - target_distance);
            end
        end
        
    end
    disp(itertime)
end

%%
% 找到每行绝对值最小值的索引，即是第几列
[~, min_col_indices] = min(abs(EFG_matrix), [], 2);

disp(['第1组音爆分别对应检测设备A、B、C、D、E、F、G的序号 ', num2str([1, sorted_results(1, 1:3), min_col_indices(1:3)'])]);

%% 目标函数
function total_diff = objective_function(params, data, data_matrix, device_combination)
    x = params(1);
    y = params(2);
    z = params(3);
    c = params(4);

    total_diff = 0;

    for idx = 1:4
        target_distance = (data_matrix(idx, device_combination(idx)) + c)^2;
        actual_distance = (x - data.X_km(idx))^2 + (y - data.Y_km(idx))^2 + (z - data.Z_km(idx))^2;
        difference = abs(actual_distance - target_distance);
        total_diff = total_diff + difference;
    end
    
    total_diff = total_diff / 4;
end