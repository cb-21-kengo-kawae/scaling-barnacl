import deepExtend from 'deep-extend';
import railsTranslations from './rails/rails-translations.yml';

import common from './common.yml';
import { common as designpackCommon } from 'fs-designpack4.0/src/locales/common.js';

export default deepExtend({}, railsTranslations, designpackCommon, common);
