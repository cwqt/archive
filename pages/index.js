import Page from "../layouts/Page";
import StoreList from "../layouts/StoreList";

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
        designed and manufactured in cardiff, wales.
      </p>
    </div>
  </Page>
);

export default Index;
