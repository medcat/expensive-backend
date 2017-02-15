import React from "react";
import ReactDOM from "react-dom";
import {Router, Route, IndexRoute, browserHistory, hashHistory} from "react-router";
import Expensive from "Expensive";
import "index.scss";

const history = process.env.NODE_ENV == "production" ?
  browserHistory : hashHistory;

function renderBody() {
  ReactDOM.render((
    <Router history={history}>
      <Route path="/" component={Expensive.Application}>
        <IndexRoute component={Expensive.Home} />
        <Route path="/session/login" component={Expensive.Session.Login} />
        <Route path="/session/logout" component={Expensive.Session.Logout} />
        <Route path="/session/register" component={Expensive.Session.Register} />
      </Route>
    </Router>
  ), document.getElementById("root"));
}

Expensive.authentication.renewToken().then(renderBody, renderBody);
