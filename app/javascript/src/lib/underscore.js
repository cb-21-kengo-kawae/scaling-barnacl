import _ from 'underscore';
import underscored from 'underscore.string/underscored';

import deepExtend from 'deep-extend';

const targets = [
  'chain',
  'difference',
  'each',
  'extend',
  'every',
  'first',
  'has',
  'invert',
  'indexBy',
  'isDate',
  'isEmpty',
  'isFunction',
  'isNaN',
  'isNull',
  'isNumber',
  'isObject',
  'isUndefined',
  'last',
  'mapObject',
  'max',
  'min',
  'pick',
  'pluck',
  'range',
  'reject',
  'sortBy',
  'union',
  'throttle'
];

const missing = targets.find(methodName => !_[methodName]);

if (missing) {
  throw new Error(`Underscore.${missing} is not defined`);
}

export default Object.assign(
  {
    /**
     * zelda-action の isBlank は underscore.string によるものだが、
     * underscore.string はこれ以外に使っていないので、underscore.string の実装を真似る。
     *
     * @param {string}
     * @return {boolean}
     * @see {@link https://github.com/epeli/underscore.string/blob/master/isBlank.js}
     */
    isBlank: function (s) {
      const str = s == null ? '' : `${s}`;
      return /^\s*$/.test(str);
    },

    /**
     * javascript では Function, Array も Object の亜種なので、
     * _.isObject は Function, Array でも true を返すが、
     * このメソッドは {} のみを true とする。
     *
     * @param {Object} value
     * @returns {boolean}
     */
    isSimpleObject: function (value) {
      return _.isObject(value) && !_.isArray(value) && !_.isFunction(value);
    },

    /**
     * ネストしたオブジェクトに対しても参照を持たない、マージされた新しいオブジェクトを返す。
     *
     * @param {...Object}
     * @returns {Object}
     */
    deepExtend: deepExtend,

    /**
     * @see https://github.com/epeli/underscore.string#underscoredstring--string
     * @param {string}
     * @returns {string}
     */
    underscored: underscored
  },

  _.pick(_, ...targets)
);
