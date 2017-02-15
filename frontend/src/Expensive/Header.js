import React from "react";
import {Link} from "react-router";
import {authentication} from "Expensive/authentication";

export default class Header extends React.Component {
  render() {
    return (
      <div className="header">
        <div className="header-container">
          <h1 className="header-title">
            <Link to="/" className="header-title-link">Expensive</Link>
          </h1>
          {authentication.hasToken() ?
              this.userNavigation() :
              this.guestNavigation()}
        </div>
      </div>
    );
  }

  userNavigation() {
    return (
      <nav className="header-navigation">
        <Link to="/session/logout" className="header-navigation-link">Logout</Link>
        <Link to="/settings" className="header-navigation-link">Settings</Link>
        <Link to="/dashboard" className="header-navigation-link">Dashboard</Link>
      </nav>
    );
  }

  guestNavigation() {
    return (
      <nav className="header-navigation">
        <Link to="/session/login" className="header-navigation-link">Login</Link>
        <Link to="/session/register" className="header-navigation-link">Register</Link>
      </nav>
    );
  }
}
