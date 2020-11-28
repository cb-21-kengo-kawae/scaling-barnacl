process.env.NODE_ENV = process.env.NODE_ENV || "development";
process.env.VUE_APP_I18N_LOCALE = "ja";
process.env.VUE_APP_I18N_FALLBACK_LOCALE = "en";

const environment = require("./environment");

const config = environment.toWebpackConfig();
config.devtool = "sourcemap";

module.exports = config;
