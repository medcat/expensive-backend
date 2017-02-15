import Promise from "promise-polyfill";

let authentication = {
  hasToken() {
    return !!this.token;
  },

  authenticatedRequest(options) {
    let passed = Object.assign({}, options,
      { headers: { "Authorization": "Bearer " + this.token} });

    return $.ajax(passed);
  },

  renewToken() {
    if(!this.hasToken()) { return Promise.reject(false); }
    return this.authenticatedRequest({
      url: "api/session/renew.json",
      headers: { "Authenticate": "Bearer " + this.token },
      timeout: 200,
    }).fail(() => this.clearToken());
  },

  attemptLogin(email, password) {
    return $.ajax({
      type: "POST",
      url: "/api/session.json",
      data: { session: { email, password } }
    }).then((data) => {
      this.token = data.token;
    });
  },

  clearToken() {
    if(window.localStorage) {
      localStorage.removeItem("token");
    }

    delete this._token;
  },

  set token(token) {
    if(window.localStorage) {
      localStorage.setItem("token", token);
    }

    this._token = token;
  },

  get token() {
    return this._token ||
      (window.localStorage && window.localStorage.getItem("token"));
  }
};

export {authentication};
