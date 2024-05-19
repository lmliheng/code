%%
clear;
clc;

%% 导入数据
data4 = readtable('data3.xlsx');
newColumnNames = {'device', 'lon', 'lat', 'height', 'time1', 'time2', 'time3', 'time4'};
data4.Properties.VariableNames(:) = newColumnNames;

% disp(data4(1:5,:));

%% 数据转换
data4.X_km = (data4.lon - 110.241) * 97.304;
data4.Y_km = (data4.lat - 27.204) * 111.263;
data4.Z_km = data4.height / 1000;
data4.R1_km = data4.time1 * 340 / 1000;
data4.R2_km = data4.time2 * 340 / 1000;
data4.R3_km = data4.time3 * 340 / 1000;
data4.R4_km = data4.time4 * 340 / 1000;

% disp(data4(:, {'X_km', 'Y_km', 'Z_km', 'R1_km', 'R2_km', 'R3_km', 'R4_km'}));

%%
data_matrix = table2array(data4(:, {'R1_km', 'R2_km', 'R3_km', 'R4_km'}));

result_group2 = [4, 4, 2, 1, 4, 1, 3];


%% 定义随机次数
sum_time = 10;

result_Group2 = zeros(sum_time, 7+4+7);

for calculate_time = 1:sum_time
    data_array = zeros(1, 7);
    
    % 生成每次随机中的扰动
    for i = 1:7
        result_Group2(calculate_time, i) = rand(1) - 0.5;
        data_array(i) = data_matrix(i, result_group2(i)) + result_Group2(calculate_time, i) * 340 / 1000 ;
    end
    
    %% 定义范围
    bounds = [-100 100; -100 100; 10 30; -100 500];
    
    opt_R_abs = 100;

    for opt_time = 1:20

        %% 优化求解
        options = optimoptions('particleswarm', 'Display', 'none');
        [result, fval, exitflag, output] = particleswarm(@(params) objective_function(params, data4, data_array), 4, bounds(:,1), bounds(:,2), options);
        
        %% 结果输出
        if exitflag > 0
            fitted_point = result;

            % if fitted_point(4) / 340 < opt_t

                temp_result_Group2 = zeros(1, 7+4+7);

                temp_result_Group2(1, 8) = fitted_point(1) / 97.304 + 110.241;
                temp_result_Group2(1, 9) = fitted_point(2) / 111.263 + 27.204;
                temp_result_Group2(1, 10) = fitted_point(3) * 1000;
                temp_result_Group2(1, 11) = fitted_point(4) / 340;
            
                x = fitted_point(1);
                y = fitted_point(2);
                z = fitted_point(3);
                c = fitted_point(4);
            
                for index = 1:size(data4, 1)
                    actual_distance = sqrt((x - data4.X_km(index))^2 + (y - data4.Y_km(index))^2 + (z - data4.Z_km(index))^2);
                    target_distance = data_array(index) + c;
                    point = data4.device{index};
                    temp_result_Group2(1, 11+index) = actual_distance - target_distance;
                end

                if sum(abs(temp_result_Group2(:, 12:18)), 2) ~= 0
                    if sum(abs(temp_result_Group2(:, 12:18)), 2) < opt_R_abs
                        result_Group2(calculate_time, 8:18) = temp_result_Group2(1, 8:18);
                        opt_R_abs = sum(abs(temp_result_Group2(:, 12:18)), 2);
                    end
                end

            % end
        end
    
        disp(['第', num2str(calculate_time), '组扰动，', '第', num2str(opt_time), '次计算'])
    end
end

%% 保存结果
final_result_Group2 = result_Group2;
final_result_Group2(:, 19) = sum(abs(final_result_Group2(:, 12:18)), 2);

T = array2table(final_result_Group2);

T.Properties.VariableNames = {'观测点A时间误差(s)', '观测点B时间误差(s)', '观测点C时间误差(s)', '观测点D时间误差(s)', ...
                              '观测点E时间误差(s)', '观测点F时间误差(s)', '观测点G时间误差(s)', ...
                              '音爆经度(°)', '音爆纬度(°)', '音爆高程(m)', '音爆时间(s)', ...
                              '距观测点A误差(km)', '距观测点B误差(km)', '距观测点C误差(km)', '距观测点D误差(km)', ...
                              '距观测点E误差(km)', '距观测点F误差(km)', '距观测点G误差(km)', ...
                              '七个观测点误差绝对值之和(km)'};

filename = 'final_result_Group2.xlsx';

writetable(T, filename);

writetable(T, filename, 'Sheet', 'Sheet1');

disp('结果已保存到final_result_Group2.xlsx中')
%%
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