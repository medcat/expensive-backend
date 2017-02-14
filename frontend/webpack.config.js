var path = require("path");
var HtmlWebpackPlugin = require("html-webpack-plugin");
var ExtractTextPlugin = require("extract-text-webpack-plugin")

var extractSass = new ExtractTextPlugin("assets/style.css");

module.exports = {
  entry: "index.js",
  output: {
    filename: "assets/main.js",
    path: path.resolve(__dirname, "build"),
    publicPath: "/"
  },

  module: {
    rules: [{
      test: /\.jsx?$/,
      exclude: /node_modules/,
      enforce: "pre",
      use: "eslint-loader"
    }, {
      test: /\.jsx?$/,
      exclude: /node_modules/,
      use: {
        loader: "babel-loader",
        options: {presets: ["react", ["es2015", {modules: false}]]}
      }
    }, {
      test: /\.(sass|scss|css)$/,
      use: extractSass.extract({
        fallback: "style-loader",
        use: ["css-loader", "sass-loader"]})
    }]
  },

  resolve: {
    modules: [
      "node_modules",
      path.resolve(__dirname, "src")
    ]
  },

  plugins: [
    new HtmlWebpackPlugin({ inject: true, template: "public/index.html" }),
    extractSass
  ]
}
