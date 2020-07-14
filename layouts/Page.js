import Root from "./Root";
import Header from "../components/Header";
import Footer from "../components/Footer";

export default function Page(props) {
  return (
    <Root>
      <div className="container">
        {/* <Header /> */}
        {props.children}
        {/* <Footer /> */}
      </div>
    </Root>
  );
}
