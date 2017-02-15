import React from "react";
import Header from "Expensive/Header";

export default class Application extends React.Component {
  render() {
    return (
      <div className="application">
        <Header />
        <div className="contents outer-container">
          {this.props.children}
        </div>
      </div>
    )
  }
}

Application.propTypes = {
  children: React.PropTypes.node
}
