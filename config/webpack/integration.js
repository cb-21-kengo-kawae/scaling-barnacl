process.env.NODE_ENV = process.env.NODE_ENV || "integration";
process.env.VUE_APP_I18N_LOCALE = "ja";
process.env.VUE_APP_I18N_FALLBACK_LOCALE = "en";

const environment = require("./environment");

const fileLoader = environment.loaders.get("file");
fileLoader.use[0].options.publicPath = `${process.env.WEBPACKER_ASSET_HOST}/template4th/packs/`;

module.exports = environment.toWebpackConfig();
