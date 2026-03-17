<script setup>
</script>

<template>
  <div class="home-container">
    <el-card class="welcome-card">
      <h1>欢迎使用 DoQ 在线题库</h1>
      <p>这是一个专业的在线学习和刷题平台</p>
    </el-card>
    
    <el-row :gutter="20" class="feature-row">
      <el-col :span="6">
        <el-card shadow="hover" class="feature-card">
          <el-icon :size="40" color="#409EFF"><Document /></el-icon>
          <h3>海量题库</h3>
          <p>丰富的题目资源，覆盖各个知识点</p>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover" class="feature-card">
          <el-icon :size="40" color="#67C23A"><Edit /></el-icon>
          <h3>智能组卷</h3>
          <p>根据需求智能生成模拟试卷</p>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover" class="feature-card">
          <el-icon :size="40" color="#E6A23C"><Box /></el-icon>
          <h3>错题记录</h3>
          <p>自动记录错题，针对性复习</p>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover" class="feature-card">
          <el-icon :size="40" color="#F56C6C"><DataLine /></el-icon>
          <h3>学习分析</h3>
          <p>详细的学习数据和进度追踪</p>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<style scoped>
.home-container {
  padding: 20px;
}

.welcome-card {
  text-align: center;
  margin-bottom: 30px;
}

.welcome-card h1 {
  margin: 0 0 10px 0;
  color: #333;
}

.welcome-card p {
  margin: 0;
  color: #666;
  font-size: 16px;
}

.feature-row {
  margin-top: 20px;
}

.feature-card {
  text-align: center;
}

.feature-card h3 {
  margin: 15px 0 10px 0;
  color: #333;
}

.feature-card p {
  margin: 0;
  color: #666;
  font-size: 14px;
}
</style>
