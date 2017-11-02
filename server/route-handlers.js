/*!
 * Copyright (c) 2015-present, Okta, Inc. and/or its affiliates. All rights reserved.
 * The Okta software accompanied by this notice is provided pursuant to the Apache License, Version 2.0 (the "License.")
 *
 * You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0.
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *
 * See the License for the specific language governing permissions and limitations under the License.
 */

/* eslint brace-style:0, no-param-reassign:0, import/no-extraneous-dependencies:0, no-shadow:0, no-return-assign:0 */

'use strict';

const config = require('../.samples.config.json');
const handlers = module.exports = {};

/**
 * Index page - lists the scenarios that the developer can choose from
 *
 * Route: /
 */
handlers.main = (req, res) => {
  res.render('index', { config });
};
