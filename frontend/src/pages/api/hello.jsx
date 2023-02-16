import Hello from "../../componnets/helloworld";

const Helloworld = (req, res) => {
  res.status(200).json({ name: "John Doe" });
  return <Hello />;
};

export default Helloworld;
