export default class SystemErrorHandler {
  constructor(localization) {
    this.localization = localization;
  }

  install(Vue) {
    Vue.prototype.$alertSystemError = error => {
      window.alert(this.localization.translate('common.system_error'));

      // 開発モードの場合はコンソールにエラーを表示する。
      // eslint-disable-next-line no-console
      Vue.config.devtools && console.error(error);
    };
  }
}
