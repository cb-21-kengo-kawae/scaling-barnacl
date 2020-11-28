const config = document.querySelector('script[name="config"]').dataset;
const separator = '.';

const keywords = [config.namespace, config.service, 'data'];
const namespace = keywords.join(separator);
const namespaceRegex = new RegExp('^' + namespace + separator);

const versionName = 'version';
const versionKey = [config.namespace, config.service, versionName].join(separator);

/**
 * storageが利用可能な場合返却する
 *
 * @params {string} storageName:
 * @return {object|boolean} 利用できない場合 false
 */
const getStorage = storageName => {
  const item = 'check_local_storage';
  try {
    window[storageName].setItem(item, item);
    window[storageName].removeItem(item);
    return window[storageName];
  } catch (e) {
    return false;
  }
};

const namingKey = key => {
  return [namespace, key].join('.');
};

/**
 * LocalStorage
 */
export default class LocalStorage {
  constructor() {
    this.storage = getStorage('localStorage') || getStorage('sessionStorage');

    /**
     * storageに記録されているversionが異なる場合、keyを削除する
     */
    if (config[versionName] !== this.storage.getItem(versionKey)) {
      this.clear();
      this.storage.setItem(versionKey, config[versionName]);
    }
  }

  /**
   * @return {void}
   */
  setItem(key, value) {
    this.storage.setItem(namingKey(key), JSON.stringify(value));
  }

  /**
   * @return {object}
   */
  getItem(key) {
    const value = this.storage.getItem(namingKey(key));
    return value && JSON.parse(value);
  }

  /**
   * @return {void}
   */
  removeItem(key) {
    this.storage.removeItem(namingKey(key));
  }

  /**
   * @return {array} cleared
   */
  clear() {
    const cleared = [];

    Object.keys(this.storage).forEach(key => {
      if (namespaceRegex.test(key)) {
        this.storage.removeItem(key);
        cleared.push(key);
      }
    });

    return cleared;
  }
}
