import "../scss/main.scss";
import Head from "next/head";

export default function Root(props) {
  return (
    <div>
      <Head>
        <title>daughter.systems</title>
        <link
          rel="stylesheet"
          type="text/css"
          href="https://cdnjs.cloudflare.com/ajax/libs/normalize/7.0.0/normalize.css"
        />
        <link
          rel="stylesheet"
          type="text/css"
          charSet="UTF-8"
          href="https://cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.6.0/slick.min.css"
        />
        <link
          rel="stylesheet"
          type="text/css"
          href="https://cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.6.0/slick-theme.min.css"
        />
        <link rel="icon" type="image/png" href="/static/daughtersystems.png" />
      </Head>

      {props.children}
    </div>
  );
}
