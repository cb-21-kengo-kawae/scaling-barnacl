export default {
  install(Vue) {
    Vue.filter('percentage', (decimal, format = '0,0.00') => {
      return `${Vue.options.filters.number((decimal || 0) * 100, format)}%`;
    });
  }
};
