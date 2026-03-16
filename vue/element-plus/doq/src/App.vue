<script setup>
import { ref } from 'vue'

const activeIndex = ref('1')
const handleSelect = (key, keyPath) => {
  console.log(key, keyPath)
}
</script>

<template>
  <el-menu
    :default-active="activeIndex"
    mode="horizontal"
    :ellipsis="false"
    @select="handleSelect"
  >
    <el-menu-item index="1">首页</el-menu-item>
    <el-menu-item index="2">产品中心</el-menu-item>
    <el-menu-item index="3">解决方案</el-menu-item>
    <el-menu-item index="4">关于我们</el-menu-item>
    <div class="flex-grow" />
    <el-menu-item index="5">登录</el-menu-item>
    <el-menu-item index="6">注册</el-menu-item>
  </el-menu>
</template>

<style scoped>
.flex-grow {
  flex-grow: 1;
}
</style>
