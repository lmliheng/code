import { createRouter, createWebHistory } from 'vue-router'
// import Login from '../views/Login.vue'

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('../views/Login.vue')  //component 
  },
  {
    path: '/',
    name: 'Home',
    component: () => import('../views/Home.vue')
  },
  {
    path: '/question-bank',
    name: 'QuestionBank',
    component: () => import('../views/QuestionBank.vue')
  },
  {
    path: '/generate-exam',
    name: 'GenerateExam',
    component: () => import('../views/GenerateExam.vue')
  },
  {
    path: '/wrong-questions',
    name: 'WrongQuestions',
    component: () => import('../views/WrongQuestions.vue')
  },
    {
    path: '/register',
    name: 'Register',
    component: () => import('../views/register.vue')
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
