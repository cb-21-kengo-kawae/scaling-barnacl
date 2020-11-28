import Vue from 'vue';
import VueRouter from 'vue-router';

import SelectTodo from '@pages/select_todo/Index.vue';

Vue.use(VueRouter);

const routes = [
  {
    path: '/',
    redirect: { name: 'select_todo' }
  },
  {
    path: '/select_todo',
    component: SelectTodo,
    name: 'select_todo'
  }
];

const router = new VueRouter({
  base: '/template4th',
  mode: 'history',
  routes
});

export default router;
