import React from "react";
import {Link} from "react-router";

export default class Modal extends React.Component {
  render() {
    return (
      <form className="user-form modal" onSubmit={this.props.onSubmit}>
        <h1 className="user-form-title">Register</h1>
        {this.props.status == "error" ? this.errorMessage() : ""}
        <input className="user-form-input" name="email" type="email"
          placeholder="email" onChange={this.props.onUpdate}
          disabled={this.props.status == "loading"} />
        <input className="user-form-input" name="password"
          type="password" placeholder="password"
          onChange={this.props.onUpdate}
          disabled={this.props.status == "loading"} />
        <input className="user-form-input" name="passwordConfirmation"
          type="password" placeholder="password confirmation"
          onChange={this.props.onUpdate}
          disabled={this.props.status == "loading"} />
        <div className="user-form-actions">
          <input className="user-form-button" type="submit"
            disabled={this.props.status == "loading"} />
          <Link to="/register" className="user-form-link">Register</Link>
        </div>
      </form>
    )
  }

  errorMessage() {
    return (
      <div className="errors">
        Whoa!  That didn't seem to be right.  Let's try again...
      </div>
    );
  }
}

Modal.propTypes = {
  status: React.PropTypes.string.isRequired,
  onSubmit: React.PropTypes.func.isRequired,
  onUpdate: React.PropTypes.func.isRequired,
}
