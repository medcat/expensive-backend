import React from "react";
import Modal from "Expensive/Session/Register/Modal";

export default class Register extends React.Component {
  constructor(props) {
    super(props);

    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleUpdate = this.handleUpdate.bind(this);
    this.state = {status: "normal",
      email: "",
      password: "",
      passwordConfirmation: ""};
  }

  handleSubmit() {
    event.preventDefault();
  }

  handleUpdate(event) {
    this.setState({[event.target.name]: event.target.value});
  }

  render() {
    return (
      <div className="action-register">
        <div className="user-register-background"></div>,
        <section className="contents outer-container">
          <Modal
            status={this.state.status}
            onSubmit={this.handleSubmit}
            onUpdate={this.handleUpdate}
          />
        </section>
      </div>
    );
  }
}
