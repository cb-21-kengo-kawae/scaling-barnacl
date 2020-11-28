module.exports = {
  test: /\.(yml|yaml)$/,
  use: [
    {
      loader: "json-loader"
    },
    {
      loader: "yaml-loader"
    }
  ]
};
