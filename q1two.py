import numpy as np
from scipy.optimize import differential_evolution

# 设备数据字典保持不变
data = {
    'A': (110.24127, 27.204824, 824, 100.767),
    'B': (110.78027, 27.456727, 727, 112.220),
    'C': (110.71227, 27.785742, 742, 188.020),
    'D': (110.25127, 27.825850, 850, 258.985),
    'E': (110.52427, 27.617786, 786, 118.443),
    'F': (110.46727, 27.921678, 678, 266.871),
    'G': (110.04727, 27.121575, 575, 163.024)
}

# 封装1：优化打印输出并保持逻辑不变
def geo_to_cartesian(lat, lon, alt):
    R = 6371000
    x = R * np.cos(np.radians(lat)) * np.cos(np.radians(lon)) * alt
    y = R * np.cos(np.radians(lat)) * np.sin(np.radians(lon)) * alt
    z = R * np.sin(np.radians(lat)) * alt
    return x, y, z

# 封装2: 增加打印格式化并检查优化结果的有效性
def calculate_explosion_position_and_time(data):
    positions = [geo_to_cartesian(lat, lon, alt) for _, (lat, lon, alt, _) in data.items()]
    times = np.array([time for _, (_, _, _, time) in data.items()])
    
    print("Positions (x, y, z):", np.array(positions).round(3))
    print("Times:", times.round(3))

    speed_of_sound = 340

    def objective_function(variables):
        x, y, z, t0 = variables
        predicted_times = np.sqrt(np.sum((np.array(positions) - np.array([x, y, z])) ** 2, axis=1)) / speed_of_sound + t0
        return np.sum((times - predicted_times) ** 2)

    bounds = [(-1e6, 1e6), (-1e6, 1e6), (-1e6, 1e6), (0, 1e6)]
    result = differential_evolution(objective_function, bounds)

    if not result.success:
        print("Optimization did not converge successfully.")
        return None, None, None

    x, y, z, t0 = result.x
    lat, lon, alt = cartesian_to_geo(x, y, z)

    return lat, lon, alt , t0

# 封装3: 保持不变
def cartesian_to_geo(x, y, z):
    R = 6371000
    lat = np.degrees(np.arcsin(z / R))
    lon = np.degrees(np.arctan2(y, x))
    alt = np.sqrt(x**2 + y**2 + z**2) / R
    return lat, lon, alt

# 计算结果，增加对结果有效性的检查
lat, lon, alt , t0 = calculate_explosion_position_and_time(data)
if lat is not None and lon is not None and alt is not None and t0 is not None:
    print(f"残骸发生音爆时的位置：经度 {lon:.6f}°，纬度 {lat:.6f}°，高程 {alt:.2f} 米")
    print(f"残骸发生音爆时的时间：{t0:.6f} 秒")
else:
    print("无法准确计算音爆位置和时间。")