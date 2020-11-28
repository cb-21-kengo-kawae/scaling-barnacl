import Vue from 'vue';
import App from '../App';
import router from '@router';
import store from '@store';
import VueCompositionApi from '@vue/composition-api';

// -- bootstrap vue --
import BootstrapVue from 'bootstrap-vue';

// -- application scss --
import '@assets/stylesheets/application.scss';

// -- グローバルなイベントコールバックの格納場所 --
import AppEventCallbacks from '@lib/app_event_callbacks';

// -- fs-wspack --
import { AppNotification } from 'fs-wspack';

// -- Localization --
import deepExtend from 'deep-extend';
import Localization from '@lib/localization';
import translationResouces from '@locales';
import VueI18n from 'vue-i18n';

Vue.use(VueI18n);

const locales = require.context('../src/locales_design', true, /[A-Za-z0-9-_,\s]+\.(yml)$/i);
const messages = { en: { translation: {} }, ja: { translation: {} } };
locales.keys().forEach(filename => {
  const matched = filename.match(/([A-Za-z0-9-_]+)\./i);
  if (matched && matched.length > 1) {
    const name = matched[1];
    const source = locales(filename);
    messages.en.translation[name] = source.en;
    messages.ja.translation[name] = source.ja;
  }
});

const tSources = deepExtend({}, messages, translationResouces);

// -- system error handler --
import SystemErrorHandler from '@lib/system_error_handler';

// -- accordion --
import Accordion from '@components/Accordion';

// -- dayjs --
import VueDayjs from '@lib/dayjs';

// -- fs-designpack4.0 --
import {
  FAppHeader,
  FAppHeaderControl,
  FAppHeaderNavMenuItem,
  FAppHeaderNavMenu,
  FFolderContainer,
  FFolderItem,
  FSelect,
  FSelect2,
  FPopover,
  FToggle,
  FTooltip,
  FIcon,
  FToast,
  FHakase,
  FBalloon,
  FBalloonPage,
  FButton,
  FDropdownItem,
  FBreadcrumb,
  FBackgroundDot,
  FTag,
  FInputSearch,
  FDropdown
} from 'fs-designpack4.0/dist/FsDesignpack4.umd';

require.context('../../../node_modules/fs-designpack4.0/dist/fonts', true, /\.(eot|otf|ttf|woff|woff2)$/i);

require.context('../../../node_modules/fs-designpack4.0/dist/img', true, /\.(gif|jpg|png|svg)$/i);

Vue.use(VueCompositionApi);
Vue.use(BootstrapVue);
Vue.use(VueDayjs);

Vue.prototype.$path = function (params) {
  return router.resolve(params).href;
};

document.addEventListener('DOMContentLoaded', () => {
  const config = Object.assign({}, document.querySelector('script[name="config"]').dataset);
  const csrfParamTag = document.head.querySelector('meta[name="csrf-param"]');
  const csrfTokenTag = document.head.querySelector('meta[name="csrf-token"]');
  config.csrfParam = csrfParamTag && csrfParamTag.content;
  config.csrfToken = csrfTokenTag && csrfTokenTag.content;
  if (!Vue.config.devtools && config.service && config.csrfToken) {
    Vue.config.errorHandler = function (err, vm, info) {
      const path = ['', config.service, 'zeldalogging', 'logging'].join('/');
      const name = vm.$options && vm.$options.name;

      const data = {
        severity: 'ERROR',
        receiver: [info, 'in', name].join(' '),
        message: err.message,
        trace: err.stack,
        path: location.href
      };

      const formData = new FormData();

      Object.keys(data).forEach(k => {
        formData.append(`logging[${k}]`, data[k]);
      });

      const params = {
        credentials: 'same-origin',
        headers: { 'X-CSRF-TOKEN': config.csrfToken },
        method: 'POST',
        body: formData
      };

      fetch(path, params);

      return true;
    };
  }

  const localization = new Localization(tSources, config.locale, config.timeZone);
  Vue.use(localization);

  const i18n = new VueI18n({
    locale: config.locale,
    fallbackLocale: 'ja'
  });

  const systemErrorHandler = new SystemErrorHandler(localization);
  Vue.use(systemErrorHandler);

  Vue.prototype.$appEventCallbacks = new AppEventCallbacks();

  Vue.component('AppNotification', AppNotification);
  Vue.component('FAppHeader', FAppHeader);
  Vue.component('FAppHeaderControl', FAppHeaderControl);
  Vue.component('FAppHeaderNavMenu', FAppHeaderNavMenu);
  Vue.component('FAppHeaderNavMenuItem', FAppHeaderNavMenuItem);
  Vue.component('FFolderContainer', FFolderContainer);
  Vue.component('FFolderItem', FFolderItem);
  Vue.component('FSelect', FSelect);
  Vue.component('FSelect2', FSelect2);
  Vue.component('FPopover', FPopover);
  Vue.component('FToggle', FToggle);
  Vue.component('FTooltip', FTooltip);
  Vue.component('FIcon', FIcon);
  Vue.component('FToast', FToast);
  Vue.component('FHakase', FHakase);
  Vue.component('FBalloon', FBalloon);
  Vue.component('FBalloonPage', FBalloonPage);
  Vue.component('FButton', FButton);
  Vue.component('FDropdownItem', FDropdownItem);
  Vue.component('FBreadcrumb', FBreadcrumb);
  Vue.component('FBackgroundDot', FBackgroundDot);
  Vue.component('FTag', FTag);
  Vue.component('FInputSearch', FInputSearch);
  Vue.component('FDropdown', FDropdown);

  Vue.component('VAccordion', Accordion);

  new Vue({
    components: { App },
    data() {
      return { config };
    },
    template: '<App/>',
    render: h => h(App),
    router,
    store,
    i18n
  }).$mount('#app');
});
