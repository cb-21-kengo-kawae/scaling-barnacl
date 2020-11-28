import Validator from './validator';

/**
 * VeeValidate validation rule と Rails error keyword の対応表
 * Validatorのメッセージ組み立てを利用する際に VeeValidate validation rule を Rails error keyword に置き換える必要がある
 */
const KEYWORD_MAP = {
  max: 'too_long',
  required: 'blank'
};
const PLACEHOLDER_KEY_MAP = {
  max: 'count',
  range_of_day: 'range',
  range_of_hour: 'range',
  between: 'range'
};

const ATTRIBUTE_SCOPE = 'resources.attributes';

/**
 * @see https://baianat.github.io/vee-validate/guide/localization.html#custom-i18n-driver
 */
export default class VeeDictionary {
  /**
   * @param {Localization} localization: Localization instance
   */
  constructor(localization) {
    this.customDriver = {
      get locale() {
        return localization.lang;
      },

      set locale(lang) {},

      getMessage() {},

      setMessage() {},

      /**
       * @param {string} key 形式は { model名.key名 }
       * @return {string} attribute
       */
      getAttribute(_, key) {
        return localization.t(`${ATTRIBUTE_SCOPE}.${key}`);
      },

      setAttribute() {},

      /**
       * @param {string} key 形式は { model名.key名 }
       * @param {string} rule
       * @param {object} data
       * @return {string} message: 翻訳後のエラーメッセージ
       */
      getFieldMessage(_, key, rule, data) {
        const arr = key.split('.');
        const judge = arr.length > 1;

        const model = judge ? arr[0] : null;
        const field = judge ? arr[1] : key;

        const validator = new Validator(model);
        const separator = this.locale === 'ja' ? '' : ' ';

        var rule_key = PLACEHOLDER_KEY_MAP[rule] || rule;
        const params = this.getParams(rule_key, data[1]);
        const detail = Object.assign(params, {
          error: KEYWORD_MAP[rule] || rule
        });

        return validator.errorMessage(field, detail, separator);
      },

      getParams(rule_key, args) {
        if (args[0] === null || args[0] === undefined) return {};

        if (rule_key == 'range') {
          return { from: args[0], to: args[1] };
        } else {
          return { [rule_key]: args[0] };
        }
      },

      merge() {},

      getDateFormat() {},

      setDateFormat() {}
    };
  }
}
