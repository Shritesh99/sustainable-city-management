import "@/styles/globals.css";
import { useEffect, useState } from "react";
import { Layout, Loading, LoginLayout } from "../components";
import { useRouter } from "next/router";

const MyApp = ({ Component, pageProps }) => {
	const [loading, setLoading] = useState(true);
	const router = useRouter();

	useEffect(() => {
		setLoading(false);
	});

	const isLoginPage = router.pathname.startsWith(`/user`);

    const LayoutComponent = isLoginPage ? LoginLayout : Layout;

	return (
		<LayoutComponent>
			{loading ? (
				<Loading />
			) : (
				<div className="hero-body is-align-items-flex-start">
					<Component {...pageProps} />
				</div>
			)}
		</LayoutComponent>
	);
};

export default MyApp;
