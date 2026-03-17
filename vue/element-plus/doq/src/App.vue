<script setup>
import { ref, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'

const router = useRouter()
const route = useRoute()

const activeIndex = ref('1')

const isLoginPage = computed(() => route.path === '/login') // 计算属性，判断是否是登录页
// 计算属性 可以检验s
const handleSelect = (key) => {
  const routes = {
    
    '1': '/',
    '2': '/question-bank',
    '3': '/generate-exam',
    '4': '/wrong-questions',
    '5': '/login'
  }
  if (routes[key]) {
    router.push(routes[key])
  }
}
</script>

<template>
  <router-view v-if="isLoginPage" />
  
  <div v-else class="common-layout">
    <el-container>
      <el-header>
        <el-menu :default-active="activeIndex" mode="horizontal" :ellipsis="false" @select="handleSelect">
          
            <img class="logo" src="/github.svg" alt="DoQ logo" />
         
          <el-menu-item index="1">首页</el-menu-item>
          <el-menu-item index="2">题库</el-menu-item>
          <el-menu-item index="3">生成模拟题</el-menu-item>
          <el-menu-item index="4">我的错题</el-menu-item>
          <div class="flex-grow" />
          <el-menu-item index="5">登录/注册</el-menu-item>
        </el-menu>
      </el-header>
      
      <el-main>
        <router-view />
      </el-main>
    </el-container>
  </div>
</template>

<style scoped>
.flex-grow {
  flex-grow: 1;
}

.logo {
  width: 40px;
  height: 40px;
  margin-left: 10px;
  margin-right: 10px;
  margin-top: 10px;
  margin-bottom: 10px;
}



.common-layout {
  min-height: 100vh;
}

.el-header {
  padding: 0;
  background-color: #fff;
  border-bottom: 1px solid #e4e7ed;
}

.el-main {
  background-color: #f5f7fa;
}
</style>
