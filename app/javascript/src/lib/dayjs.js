import dayjs from 'dayjs';
import relativeTime from 'dayjs/plugin/relativeTime';
import timezone from 'dayjs/plugin/timezone';

/**
 * dayjs
 */
export default {
  install(Vue) {
    dayjs.extend(relativeTime);
    dayjs.extend(timezone);

    Object.defineProperties(Vue.prototype, {
      $dayjs: {
        get() {
          return dayjs;
        }
      },
      $date: {
        get() {
          return dayjs;
        }
      }
    });

    Vue.prototype.$l = (str, format) => {
      return dayjs(str).format(format);
    };

    Vue.dayjs = dayjs;
  }
};
