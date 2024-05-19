import numpy as np
import pandas as pd
from scipy.optimize import differential_evolution

# 读取数据
data3 = pd.read_excel('data3.xlsx')
new_column_names = ['device', 'lon', 'lat', 'height', 'time1', 'time2', 'time3', 'time4']
data3.columns = new_column_names

# 数据转换
data3['X_km'] = (data3['lon'] - 110.241) * 97.304
data3['Y_km'] = (data3['lat'] - 27.204) * 111.263
data3['Z_km'] = data3['height'] / 1000
data3['R1_km'] = data3['time1'] * 340 / 1000
data3['R2_km'] = data3['time2'] * 340 / 1000
data3['R3_km'] = data3['time3'] * 340 / 1000
data3['R4_km'] = data3['time4'] * 340 / 1000

# 定义范围
bounds = [(-100, 100), (-100, 100), (0, 30), (-100, 500)]

# 优化求解
def objective_function(params, data, data_array):
    x, y, z, c = params
    total_diff = 0
    for idx in range(len(data)):
        target_distance = (data_array[idx] + c) ** 2
        actual_distance = (x - data.loc[idx, 'X_km']) ** 2 + (y - data.loc[idx, 'Y_km']) ** 2 + (z - data.loc[idx, 'Z_km']) ** 2
        difference = abs(actual_distance - target_distance)
        total_diff += difference
    total_diff /= len(data)
    return total_diff

result = differential_evolution(objective_function, bounds, args=(data3, data_array))

# 结果输出
if result.success:
    fitted_point = result.x
    print(f"经度(°): {fitted_point[0] / 97.304 + 110.241}")
    print(f"纬度(°): {fitted_point[1] / 111.263 + 27.204}")
    print(f"高程(m): {fitted_point[2] * 1000}")
    print(f"时间(s): {fitted_point[3] / 340}")

    x, y, z, c = fitted_point
    for index in range(len(data3)):
        actual_distance = np.sqrt((x - data3.loc[index, 'X_km']) ** 2 + (y - data3.loc[index, 'Y_km']) ** 2 + (z - data3.loc[index, 'Z_km']) ** 2)
        target_distance = data_array[index] + c
        point = data3.loc[index, 'device']
        print(f"相对观测点 {point} 的距离差为: {actual_distance - target_distance} km")
else:
    print(f"优化失败: {result.message}")