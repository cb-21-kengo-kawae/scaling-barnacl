import Vue from 'vue';
import Vuex from 'vuex';

import appValidationErrors from './modules/app-validation-errors';
import config from './modules/config';
import policy from './modules/policy';

Vue.use(Vuex);

export default new Vuex.Store({
  strict: process.env.NODE_ENV !== 'production' && process.env.NODE_ENV !== 'staging',
  modules: {
    appValidationErrors,
    config,
    policy,
    resources: {
      namespaced: true,
      modules: {}
    },
    pages: {
      namespaced: true,
      modules: {}
    }
  }
});
