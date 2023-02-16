// Next.js API route support: https://nextjs.org/docs/api-routes/introduction
import { useState, useEffect } from "react";
import fetch from "isomorphic-unfetch";

const baseUrl = process.env.NEXT_STATIC_BASE_URL || "http://localhost:8080";
const styles = {
  idle: {
    backgroundColor: "white",
    color: "black",
  },
  ok: {
    backgroundColor: "green",
    color: "white",
  },
  error: {
    backgroundColor: "red",
    color: "white",
  },
};

export default ({ heading, url, method }) => {
  const [state, setState] = useState("idle");
  const [response, setResponse] = useState();

  const callUrlWithMethod = async (ev) => {
    try {
      ev.preventDefault();
      const res = await fetch(baseUrl + url, { method });
      if (res.ok) {
        setState("ok");
        const data = await res.json();
        console.log(data.user);
        setResponse(
          res.status === 204 ? "STATUS CODE: 204" : await data.user.first_name
        );
      } else {
        throw await res.text();
      }
    } catch (err) {
      setState("error");
      setResponse(err.toString());
    }
  };

  return (
    <article>
      <h2>{heading}</h2>
      <pre>
        {method} {baseUrl}
        {url}
      </pre>
      <div>
        <textarea
          style={styles[state]}
          value={(state === "ok" && response) || ""}
          readOnly
        />
        {state === "error" && <p style={{ color: "red" }}>{response}</p>}
      </div>
      <div>
        <button onClick={callUrlWithMethod}>Fetch</button>
      </div>
    </article>
  );
};

// const Hello = () => {
//   // const [firstName, setFirstName] = useState("");
//   return (
//     <>
//       <div>Hello world</div>
//     </>
//   );
// };
// export default function handler(req, res) {
//   res.status(200).json({ name: 'John Doe' })
// }

// export default Hello;
