const { environment } = require("@rails/webpacker");
const path = require("path");
const { VueLoaderPlugin } = require("vue-loader");

const vue = require("./loaders/vue");
const i18n = require("./loaders/i18n");
const pug = require("./loaders/pug");
const file = require("./loaders/file");
const yaml = require("./loaders/yaml");

const webpack = require("webpack");

/**
 * resolves directory path
 *
 * @param {string} dir directory
 * @return {string} resolved path
 */
function resolve(dir) {
  return path.resolve(__dirname, dir);
}

environment.config.merge({
  resolve: {
    alias: {
      vue$: "vue/dist/vue.esm.js",
      "@oldassets": resolve("../../app/assets"),
      "@assets": resolve("../../app/javascript/src/assets"),
      "@components": resolve("../../app/javascript/src/components"),
      "@composables": resolve("../../app/javascript/src/composables"),
      "@directives": resolve("../../app/javascript/src/directives"),
      "@lib": resolve("../../app/javascript/src/lib"),
      "@locales": resolve("../../app/javascript/src/locales"),
      "@pages": resolve("../../app/javascript/src/pages"),
      "@router": resolve("../../app/javascript/src/router"),
      "@store": resolve("../../app/javascript/src/store")
    }
  }
});

environment.plugins.prepend("VueLoaderPlugin", new VueLoaderPlugin());
environment.loaders.prepend("vue", vue);
environment.loaders.prepend("i18n", i18n);
environment.loaders.prepend("pug", pug);
environment.loaders.prepend("file", file);
environment.loaders.prepend("yaml", yaml);

environment.plugins.append("Provide", new webpack.ProvidePlugin({}));

module.exports = environment;
