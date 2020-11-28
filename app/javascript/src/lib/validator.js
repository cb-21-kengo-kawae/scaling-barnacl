import Vue from 'vue';
import VeeValidate from 'vee-validate';
import VeeDictionary from './vee_dictionary';
import _ from './underscore';

const GLOBAL_ERROR_SCOPE = 'errors.messages';
const GLOBAL_ATTRIBUTE_SCOPE = 'errors.attributes';
const RESOURCE_ERROR_SCOPE = 'resources.errors';
const MODEL_ERROR_SCOPE = 'resources.errors.models';
const cache = {};

/**
 * メッセージを探索しpathを返却
 * 以下の順に探索します
 * e.g.
 * 1. resources.errors.models.user.attributes.name.blank
 * 2. resources.errors.models.user.blank
 * 3. resources.errors.messages.blank
 * 4. errors.attributes.name.blank
 * 5. errors.messages.blank
 *
 * @params {string} lang
 * @params {string} modelName
 * @params {string} columnName
 * @params {string} keyword
 */
const errorDotPath = (lang, modelName, columnName, keyword) => {
  const cacheKey = [lang, modelName, columnName, keyword].join('/');
  if (cache[cacheKey]) return cache[cacheKey];

  const errorsScope = Vue.localization.resources[lang].translation.resources.errors;
  const modelsScope = errorsScope.models;

  const modelAttrTrans =
    modelsScope[modelName] &&
    modelsScope[modelName].attributes[columnName] &&
    modelsScope[modelName].attributes[columnName][keyword];

  const modelTrans = modelsScope[modelName] && modelsScope[modelName][keyword];
  const messageTrans = errorsScope.messages && errorsScope.messages[keyword];
  const globalAttrTrans = GLOBAL_ATTRIBUTE_SCOPE[columnName];

  // e.g. resources.errors.models.user.attributes.name.blank
  if (modelAttrTrans) {
    const dotPath = [MODEL_ERROR_SCOPE, modelName, 'attributes', columnName, keyword].join('.');
    // 一度探索したpathをcacheする
    cache[cacheKey] = dotPath;

    return dotPath;
  }

  // e.g. resources.errors.models.user.blank
  if (modelTrans) {
    const dotPath = [MODEL_ERROR_SCOPE, modelName, keyword].join('.');
    cache[cacheKey] = dotPath;

    return dotPath;
  }

  // e.g. resources.errors.messages.blank
  if (messageTrans) {
    const dotPath = [RESOURCE_ERROR_SCOPE, 'messages', keyword].join('.');
    cache[cacheKey] = dotPath;

    return dotPath;
  }

  // e.g. errors.attributes.name.blank
  if (globalAttrTrans) {
    const dotPath = [GLOBAL_ATTRIBUTE_SCOPE, columnName, keyword].join('.');
    cache[cacheKey] = dotPath;

    return dotPath;
  }

  // e.g. errors.messages.blank
  const dotPath = [GLOBAL_ERROR_SCOPE, keyword].join('.');
  cache[cacheKey] = dotPath;

  return dotPath;
};

export default class Validator {
  /**
   * params {string} model名
   */
  constructor(modelName, owner) {
    this.lang = Vue.localization.lang;

    this.modelName = modelName;
    this.owner = owner;
    this.attributeScope = owner;
    this.vRules = [];

    const veeDictionary = new VeeDictionary(Vue.localization);
    const veeOption = { errorBagName: 'veeErrors' };
    VeeValidate.setI18nDriver('custom', veeDictionary.customDriver);
    VeeValidate.configure(veeOption);
    this.vee = new VeeValidate.Validator();

    // Vue のグローバルオブジェクトの翻訳機能を使う
    this.t = (...args) => {
      return Vue.localization.t(...args);
    };
  }

  /**
   * @params {array}
   * @return {void}
   */
  setRules(rules) {
    this.vRules = [...this.vRules, ...rules];
  }

  /**
   * @see https://baianat.github.io/vee-validate/guide/custom-rules.html#using-the-custom-rule
   * @return {void}
   */
  customize(...args) {
    this.vee.extend(...args);
  }

  /**
   * @see https://baianat.github.io/vee-validate/api/validator.html#verify
   * @return {promise}
   */
  async verifyAll() {
    return Promise.all(
      this.vRules.map(async r => {
        return await this.vee.verify(this.attributeScope[r.name], r.rule, {
          name: [this.modelName, _.underscored(r.localeKey) || _.underscored(r.name)].join('.')
        });
      })
    ).then(res => {
      return {
        valid: res.every(r => r.valid),
        errors: _.pluck(res, 'errors').flat()
      };
    });
  }

  /**
   * errors.detailsをもとにエラーメッセージを組み立てる
   *
   * @param {Object} details カラム毎のエラー詳細
   * @return {Array<string>} エラーメッセージの配列
   */
  errorMessages(details) {
    const separator = this.lang === 'ja' ? '' : ' ';
    const messages = [];

    Object.keys(details).forEach(colName => {
      details[colName].forEach(detail => messages.push(this.errorMessage(colName, detail, separator)));
    });

    return messages;
  }

  /**
   * @param {string} colName
   * @param {object} detail
   * @param {string} separator
   * @return {string} エラーメッセージ
   */
  errorMessage(colName, detail, separator) {
    if (!detail.error) return '';

    const keyword = detail.error;
    const colDisplayName = colName === 'base' ? '' : this.columnDisplayName(colName);
    const dotPath = errorDotPath(this.lang, this.modelName, colName, keyword);

    let trans;
    trans = colDisplayName ? [colDisplayName] : [];
    trans.push(this.t(dotPath, detail));

    return trans.join(separator);
  }

  /*
   * カラム表示名
   *
   * @param {string} columnName カラム名
   * @return {string} 表示名
   */
  columnDisplayName(columnName) {
    return this.t(['resources.attributes', this.modelName, columnName].join('.'));
  }
}
