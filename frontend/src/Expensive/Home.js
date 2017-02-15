import React from "react";
import Hero from "Expensive/Home/Hero";
import Feature from "Expensive/Home/Feature";

export default class Home extends React.Component {
  render() {
    return (
      <div className="action-home">
        <Hero />
        <section className="feature">
          <Feature kind="time" />
          <Feature kind="cost" />
          <Feature kind="stress" />
          <Feature kind="productivity" />
        </section>
      </div>
    );
  }
}

Home.Hero = Hero;
Home.Feature = Feature;
