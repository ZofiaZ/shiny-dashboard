const merge = require("webpack-merge");
const LiveReloadPlugin = require("webpack-livereload-plugin");
const commonConfig = require("./webpack.common");

const devConfig = {
  mode: "development",
  plugins: [
    new LiveReloadPlugin({
      delay: 1500,
    }),
  ],
};

module.exports = merge(commonConfig, devConfig);
