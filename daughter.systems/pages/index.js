import Page from "../layouts/Page";

const Index = () => (
  <Page>
    <div className="landing-head">
      <img src="/static/daughtersystems.png" />
      <h1>
        daughter.
        <br />
        systems
      </h1>
    </div>

    <hr />

    <div className="landing-body">
      <p>
        open-source hardware development, aiming to create unique, high-quality
        and affordable electronics.
        <br />
        <br />
        designed and manufactured in cardiff, wales by{" "}
        <a href="https://gitlab.com/cxss">cass</a>.
      </p>

      <p className="smaller">
        currently creating hats to interface with the vertical farming system;{" "}
        <a href="https://gitlab.com/cxss/mcn">mcn</a>, for the wemos d1 mini,
        esp32 & esp8266. 🌱
      </p>
    </div>
  </Page>
);

export default Index;
