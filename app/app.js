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

import OktaAuth from '@okta/okta-auth-js/jquery';

import loginRedirect from './login-redirect';
import loginCustom from './login-custom';
import logout from './logout';

const Elm = require('./Main.elm');

export function bootstrap(config) {
  const auth = new OktaAuth({
    url: config.oktaUrl,
    issuer: config.issuer,
    clientId: config.clientId,
    redirectUri: config.redirectUri,
    scopes: ['openid', 'email', 'profile'],
  });

  const containerEl = document.querySelector(config.container);
  const app = Elm.Main.embed(containerEl, {
    // https://github.com/elm-guides/elm-for-js/blob/master/Where%2520Did%2520Null%2520And%2520Undefined%2520Go.md
    user: typeof config.user !== 'undefined' ? config.user : null,
  });

  app.ports.loginRedirect.subscribe(() => {
    loginRedirect(auth);
  });

  app.ports.loginCustom.subscribe(() => {
    loginCustom(config);
  });

  app.ports.logout.subscribe(() => {
    logout(auth);
  });
}

export default bootstrap;
