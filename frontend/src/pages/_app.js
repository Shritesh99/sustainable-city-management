import "@/styles/globals.css";
import { useEffect, useState } from "react";
import { Layout, Loading } from "../components";

const MyApp = ({ Component, pageProps }) => {
	const [loading, setLoading] = useState(true);
	useEffect(() => {
		setLoading(false);
	});
	return (
		<Layout>
			{loading ? (
				<Loading />
			) : (
				<div className="hero-body is-align-items-flex-start">
					<Component {...pageProps} />
				</div>
			)}
		</Layout>
	);
};

export default MyApp;
