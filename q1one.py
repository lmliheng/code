import numpy as np

# 设备数据字典

data = {
    'A': (110.24127, 27.204824, 824, 100.767),
    'B': (110.78027, 27.456727, 727, 112.220),
    'C': (110.71227, 27.785742, 742, 188.020),
    'D': (110.25127, 27.825850, 850, 258.985),
    'E': (110.52427, 27.617786, 786, 118.443),
    'F': (110.46727, 27.921678, 678, 266.871),
    'G': (110.04727, 27.121575, 575, 163.024)
}

# 封装1：将经纬度转换为笛卡尔坐标
# 待优化
def geo_to_cartesian(lat, lon, alt):
    R = 6371000  # 地球半径，单位：米
    x = R * np.cos(np.radians(lat)) * np.cos(np.radians(lon)) * alt
    y = R * np.cos(np.radians(lat)) * np.sin(np.radians(lon)) * alt
    z = R * np.sin(np.radians(lat)) * alt
    return x, y, z


# 封装2:计算残骸发生音爆时的位置和时间
def calculate_explosion_position_and_time(data):
    # 初始化数组
    positions = []
    times = []

   # _ 是一个临时变量，用于存储字典的键（key）,不关心
    for _, (lon, lat, alt, time) in data.items():
        x, y, z = geo_to_cartesian(lat, lon, alt)
        positions.append([x, y, z])
        times.append(time)

    positions = np.array(positions)
    times = np.array(times)

    # 单元检查
    print(positions)
    print(times)

    # 音速
    speed_of_sound = 340  # 单位：米/秒，题目规定340m/s

    # 构建最小二乘问题
    def objective_function(variables):
        x, y, z, t0 = variables
        predicted_times = np.sqrt(np.sum((positions - np.array([x, y, z])) ** 2, axis=1)) / speed_of_sound + t0
        return np.sum((times - predicted_times) ** 2)

    # 使用遗传算法求解
    from scipy.optimize import differential_evolution
    bounds = [(-1e6, 1e6), (-1e6, 1e6), (-1e6, 1e6), (0, 1e6)]
    result = differential_evolution(objective_function, bounds)

    # 转换回经纬度坐标
    x, y, z, t0 = result.x
    lat, lon, _ = cartesian_to_geo(x, y, z)

    return lat, lon, t0



# 将笛卡尔坐标转换为经纬度

def cartesian_to_geo(x, y, z):
    R = 6371000  # 地球半径，单位：米
    lat = np.degrees(np.arcsin(z / R))
    lon = np.degrees(np.arctan2(y, x))
    alt = np.sqrt(x**2 + y**2 + z**2) / R
    return lat, lon, alt

# 计算结果
lat, lon, t0 = calculate_explosion_position_and_time(data)
print(f"残骸发生音爆时的位置：经度 {lon:.6f}°，纬度 {lat:.6f}°")
print(f"残骸发生音爆时的时间：{t0:.6f} 秒")