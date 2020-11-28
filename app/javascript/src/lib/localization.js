import i18next from 'i18next';
import momentTZ from 'moment-timezone';
import strftime from 'strftime';
import sprintfPostprocessor from 'i18next-sprintf-postprocessor';

i18next.use(sprintfPostprocessor);

export default class Localization {
  constructor(resources, lang, timeZone) {
    this.resources = resources;
    this.timeZone = timeZone;
    this.lang = lang;

    i18next.init({
      lng: lang,
      resources: resources,
      debug: process.env.NODE_ENV !== 'production' && process.env.NODE_ENV !== 'staging',
      saveMissing: process.env.NODE_ENV !== 'production' && process.env.NODE_ENV !== 'staging',
      interpolation: {
        prefix: '%{',
        suffix: '}',

        format: (value, format) => {
          if (value instanceof Date || value instanceof momentTZ) {
            return this.formatDate(value, format);
          }

          return value;
        }
      }
    });

    this.i18next = i18next;
  }

  translate(...args) {
    return this.i18next.t(...args);
  }

  formatDate(date, format = '%Y/%m/%d %H:%M', timeZone = this.timeZone) {
    let withTz = date;

    if (!(date instanceof momentTZ) && !(date instanceof Date)) {
      throw new Error(`Localization#formatDate takes a invalid argument type ${date.constructor.name}`);
    }

    if (date instanceof Date) {
      withTz = momentTZ(date).tz(timeZone);
    }

    return strftime(format, withTz.toDate());
  }

  t(...args) {
    return this.translate(...args);
  }

  l(date, formatName = '.short', timeZone = this.timeZone) {
    let formatKey = formatName;

    if (/^[.]/.test(formatName)) {
      formatKey = `common.time.formats${formatName}`;
    }

    return this.translate(formatKey, { date: momentTZ(date).tz(timeZone) });
  }

  install(Vue) {
    Vue.localization = this;

    Vue.prototype.$t = (...args) => {
      return this.translate(...args);
    };

    Vue.prototype.$l = (...args) => {
      return this.l(...args);
    };

    Vue.prototype.$scopedTranslation = scope => {
      return (...args) => {
        let k;
        let argList;

        [k, ...argList] = args;
        const key = `${scope}${k}`;
        return this.translate(key, ...argList);
      };
    };

    Vue.filter('t', (...args) => {
      return this.translate(...args);
    });

    Vue.filter('l', (...args) => {
      return this.l(...args);
    });
  }
}
