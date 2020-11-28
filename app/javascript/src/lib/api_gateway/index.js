import { RESOURCES } from './resources';
import Vue from 'vue';

const BASE_PATH = '/template4th/ajax';
const JSON_HEADER = {
  Accept: 'application/json',
  'Content-Type': 'application/json'
};

/**
 * pathを組み立てる
 *
 * 動的な部分(/:id 等)をparamsの値で置き換える
 * ptah内のsymbolとparamsのkeyが同名である必要がある
 *
 * @param{object} resource
 * @param{object} params
 * @return {string}
 */
const buildPath = function (resource, params) {
  let path = resource[params.action];

  Object.keys(params).forEach(key => {
    path = path.replace(`:${key}`, params[key]);
  });

  return BASE_PATH + path;
};

/**
 * pathにクエリパラメータを結合
 *
 * @param{string} path
 * @param{object} queryParams
 * @return {string}
 */
const withQuery = function (path, queryParams) {
  if (!queryParams) return path;

  const urlParams = new URLSearchParams(Object.entries(queryParams));
  return path + '?' + urlParams;
};

// リクエスト中のXHRをキャンセルするためのコントローラー
const abortController = new AbortController();

/**
 * リクエスト時に利用するエラーオブジェクト。
 * リクエストエラーが発生した時に例外として上げて reject で伝播する仕組み。
 **/
class ResponseError extends Error {
  /**
   * @param {string} msg - エラーメッセージ
   * @param {string} path - リクエストパス
   * @param {Number} status - HTTP ステータス
   * @param {Object} params - リクエストパラメーター
   **/
  constructor(msg, path, status, params) {
    super(msg);
    this.path = path;
    this.status = status;
    this.params = params;
  }
}

/**
 * API Gateway
 *
 */
export default class Gateway {
  /**
   * params {string} resource: リソース名
   */
  constructor(resource) {
    if (!RESOURCES[resource]) throw new Error('Resource not found');

    this.resource = resource;
    this.requestParams = null;

    // Vue のグローバルオブジェクトの翻訳機能を使う
    this.t = (...args) => {
      return Vue.localization.t(...args);
    };

    this.responseHandlers = {
      200: response => {
        return response.json().then(body => ({ status: response.status, body: body }));
      },

      401: () => {
        abortController.abort();
        alert(this.t('vuelinks.http_errors.unauthorized'));
        window.document.location.reload();
      },

      404: (response, path, params) => {
        abortController.abort();
        alert(this.t('resources.errors.messages.not_found'));
        throw new ResponseError('Resource not found', path, response.status, params);
      },

      422: response => {
        return response.json().then(body => ({ status: response.status, body: body }));
      },

      other: (response, path, params) => {
        abortController.abort();
        throw new ResponseError('Something went wrong', path, response.status, params);
      }
    };
  }

  response(response, path, params, responseHandlers = {}) {
    const status = response.status;
    return (responseHandlers[status] || this.responseHandlers[status] || responseHandlers.other || this.responseHandlers.other)(
      response,
      path,
      params
    );
  }

  get(params, requestParams = null, responseHandlers = {}) {
    if (!RESOURCES[this.resource][params.action]) throw new Error('No Actions found');

    let path = buildPath(RESOURCES[this.resource], params);
    if (requestParams) {
      path = withQuery(path, requestParams);
    }

    return fetch(path, { signal: abortController.signal }).then(result => {
      return this.response(result, path, params, responseHandlers);
    });
  }

  post(params, requestParams = null, responseHandlers = {}) {
    if (!RESOURCES[this.resource][params.action]) throw new Error('No Actions found');

    const path = buildPath(RESOURCES[this.resource], params);

    return fetch(path, {
      method: 'POST',
      headers: JSON_HEADER,
      body: JSON.stringify(requestParams),
      signal: abortController.signal
    }).then(result => {
      return this.response(result, path, params, responseHandlers);
    });
  }

  put(params, requestParams = null, responseHandlers = {}) {
    if (!RESOURCES[this.resource][params.action]) throw new Error('No Actions found');

    const path = buildPath(RESOURCES[this.resource], params);

    return fetch(path, {
      method: 'PUT',
      headers: JSON_HEADER,
      body: JSON.stringify(requestParams),
      signal: abortController.signal
    }).then(result => {
      return this.response(result, path, params, responseHandlers);
    });
  }

  delete(params, requestParams = null, responseHandlers = {}) {
    if (!RESOURCES[this.resource][params.action]) throw new Error('No Actions found');

    const path = buildPath(RESOURCES[this.resource], params);

    return fetch(path, {
      method: 'DELETE',
      headers: JSON_HEADER,
      body: JSON.stringify(requestParams),
      signal: abortController.signal
    }).then(result => {
      return this.response(result, path, params, responseHandlers);
    });
  }
}

// 外からでも利用可能なように公開する
Gateway.ResponseError = ResponseError;
