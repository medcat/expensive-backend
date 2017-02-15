import React from "react";import "images/desk.jpg";

export default class Hero extends React.Component {
  render() {
    return (
      <section className="hero">
        <h1 className="hero-header">Expensive</h1>
        <hr className="hero-seperator" />
        <h2 className="hero-tagline">Collect your thoughts.  Manage your expenses.</h2>
      </section>
    );
  }
}
