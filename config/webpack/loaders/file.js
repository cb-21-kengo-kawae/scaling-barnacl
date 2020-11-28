const { resolve } = require("path");
const { env } = require("process");
const { safeLoad } = require("js-yaml");
const { readFileSync } = require("fs");
const configPath = resolve("config", "webpacker.yml");
const settings = safeLoad(readFileSync(configPath), "utf8")[env.RAILS_ENV || env.NODE_ENV];

module.exports = {
  test: new RegExp(`(${settings.static_assets_extensions.join("|")})$`, "i"),
  use: [
    {
      loader: "file-loader",
      options: {
        name(file) {
          if (file.includes(settings.source_path)) {
            // app/javascript
            return "media/[path][name]-[hash].[ext]";
          } else if (file.includes("fs-designpack")) {
            // fs-designpack4.0
            return "js/[folder]/[name].[ext]";
          }
          return "media/[folder]/[name]-[hash:8].[ext]";
        },
        publicPath: "/template4th/packs",
        esModule: false
      }
    }
  ]
};
