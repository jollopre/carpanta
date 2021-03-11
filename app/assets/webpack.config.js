const path = require('path');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const { WebpackManifestPlugin } = require('webpack-manifest-plugin');

const publicPath = path.sep;

module.exports = {
  entry: {
    styles: './index.scss',
    index: './index.js'
  },
  plugins: [
    new MiniCssExtractPlugin({
      filename: '[name].[contenthash].css'
    }),
    new WebpackManifestPlugin({
      fileName: 'manifest.json',
      publicPath
    })
  ],
  output: {
    filename: '[name].[contenthash].js',
    path: path.resolve(__dirname, 'dist'),
    clean: true,
    publicPath
  },
  module: {
    rules: [
      {
        test: /\.s[ac]ss$/i,
        use: [
          MiniCssExtractPlugin.loader,
          "css-loader",
          "sass-loader",
        ],
      },
      {
        test: /\.(woff|gif|png)$/i,
        type: "asset/resource"
      }
    ],
  },
  stats: {
    children: true
  },
  mode: 'production'
};
