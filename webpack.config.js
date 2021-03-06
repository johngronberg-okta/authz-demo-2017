/*!
 * Copyright (c) 2015-2016, Okta, Inc. and/or its affiliates. All rights reserved.
 * The Okta software accompanied by this notice is provided pursuant to the Apache License, Version 2.0 (the "License.")
 *
 * You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0.
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *
 * See the License for the specific language governing permissions and limitations under the License.
 */

/* eslint import/no-unresolved:0 import/no-extraneous-dependencies:0, no-console:0 */
const path = require('path');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const webpack = require('webpack');

const semanticUiDir = require.resolve('semantic-ui-css/semantic.min.css');
const outPath = path.resolve(__dirname, 'dist');

console.log(`Building frontend assets into ${outPath}`);

module.exports = {
  entry: {
    bundle: [
      './app/app.js',
    ],
  },
  output: {
    path: outPath,
    filename: '[name].js',
    library: '[name]',
  },
  devtool: 'source-map',
  plugins: [
    new CopyWebpackPlugin([
      { from: semanticUiDir, to: 'css/semantic-ui' },
      { from: 'public/images', to: 'images' },
    ]),
    new webpack.ProvidePlugin({
      jQuery: 'jquery',
    }),
  ],
  module: {
    loaders: [
      {
        loader: 'babel-loader',
        test: /\.js$/,
        include: path.join(__dirname, 'app'),
        query: {
          presets: ['es2015'],
        },
      },
      {
        test: /\.elm$/,
        include: path.join(__dirname, 'app'),
        loader: 'elm-webpack-loader',
      },
      {
        test: /\.css$/,
        include: path.join(__dirname, 'app'),
        loader: [
          'style-loader',
          'css-loader'
        ]
      }
    ],
  },
};
