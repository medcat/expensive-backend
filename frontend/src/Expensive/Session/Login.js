import React from "react";
import Modal from "Expensive/Session/Login/Modal";
import {authentication} from "Expensive/authentication";

export default class Login extends React.Component {
  constructor(props) {
    super(props);

    this.handleUpdateEmail = this.handleUpdateEmail.bind(this);
    this.handleUpdatePassword = this.handleUpdatePassword.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.state = {email: "", password: "", status: "normal"};
  }

  handleSubmit() {
    event.preventDefault();
    if(this.state.status == "loading")
      return;

    this.setState({ status: "loading" });

    authentication
      .attemptLogin(this.state.email, this.state.password)
      .then(() => this.props.router.push("/"))
      .fail(() => this.setState({ status: "error" }));
  }

  handleUpdateEmail(event) {
    this.setState({ email: event.target.value, error: false });
  }

  handleUpdatePassword(event) {
    this.setState({ password: event.target.value, error: false });
  }

  render() {
    return (
      <div className="action-login">
        <div className="user-login-background"></div>,
        <section className="contents outer-container">
          <Modal
            status={this.state.status}
            onSubmit={this.handleSubmit}
            onUpdateEmail={this.handleUpdateEmail}
            onUpdatePassword={this.handleUpdatePassword}
          />
        </section>
      </div>
    );
  }
}

Login.propTypes = {
  router: React.PropTypes.object.isRequired,
}
