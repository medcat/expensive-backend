var path = require("path");
var HtmlWebpackPlugin = require("html-webpack-plugin");
var ExtractTextPlugin = require("extract-text-webpack-plugin");
var webpack = require("webpack");
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
        options: {
          presets: ["react", ["es2015", {modules: false}]]
        }
      }
    }, {
      test: /\.(sass|scss|css)$/,
      use: extractSass.extract({
        fallback: "style-loader",
        use: ["css-loader", "resolve-url-loader", "sass-loader?sourceMap"]})
    }, {
      test: /\.(jpg|png|svg|gif)$/,
      use: {
        loader: "file-loader",
        options: {
          name: "[sha256:hash:base62].[name].[ext]",
          publicPath: "images/",
          outputPath: "assets/images/"
        }
      }
    }]
  },

  resolve: {
    modules: [
      "node_modules",
      path.resolve(__dirname, "src")
    ]
  },

  plugins: [
    new HtmlWebpackPlugin({ inject: true, template: "src/index.html" }),
    new webpack.ProvidePlugin({ $: "jquery" }),
    extractSass
  ],

  devServer: {
    proxy: {
      "/api/**": {
        target: "http://localhost:3000",
        secure: false
      }
    }
  }
}
