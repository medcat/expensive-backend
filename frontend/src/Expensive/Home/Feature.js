import React from "react";

export default class Feature extends React.Component {
  render() {
    return (
      <section className="feature-item">
        <img className="feature-item-icon" src={this.featureIcon()} />
        <p className="feature-item-body">{this.featureBody()}</p>
      </section>
    );
  }

  featureIcon() {
    switch(this.props.kind) {
      case "time":
      case "cost":
      case "stress":
      case "productivity":
      default:
        return "//placehold.it/150x150.png";
    }
  }

  featureBody() {
    switch(this.props.kind) {
      case "time":
        return "Expensive allows you to save time by organising your " +
          "spending, and aggregating expenses into a simple, easy to read " +
          "report.";
      case "cost":
        return "Expensive is free to try, and easy to use.  It allows you " +
          "to track down patterns, and find a way to optimize your spending.";
      case "stress":
        return "Expensive has an easy-to-use interface, allowing you to " +
          "take it easy. Whether you're managing your team's expenses, " +
          "filing expenses yourself, or just building a report, it's just a " +
          "simple click away.";
      case "productivity":
        return "Expensive allows you to easily keep track of all of your " +
          "expenses, allowing you to focus on more important things.";
    }
  }
}

Feature.propTypes = {
  kind: React.PropTypes.string.isRequired
}
