import Head from "next/head";
import HelloWorld from "../componnets/helloworld";

export default () => (
  <main>
    <Head>
      <title>node-cors-client</title>
      <meta name="viewport" content="initial-scale=1.0, width=device-width" />
    </Head>

    <section>
      <HelloWorld heading="Helloworld" url="/user/1" method="GET" />
    </section>
  </main>
);
