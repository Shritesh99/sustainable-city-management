import "@/styles/globals.css";
import { useEffect, useState } from "react";
import { Layout, Loading, LoginLayout } from "../components";
import { useRouter } from "next/router";
import { userService } from '../services';
import {Nav} from "../components";

const MyApp = ({ Component, pageProps }) => {
	const [loading, setLoading] = useState(true);
	const [authorized, setAuthorized] = useState(false);
	
	const router = useRouter();

	useEffect(() => {
		setLoading(false);
	});

	useEffect(() => {
        // run auth check on initial load
        authCheck(router.asPath);

        // set authorized to false to hide page content while changing routes
        const hideContent = () => setAuthorized(false);
        router.events.on('routeChangeStart', hideContent);

        // run auth check on route change
        router.events.on('routeChangeComplete', authCheck)

        // unsubscribe from events in useEffect return function
        return () => {
            router.events.off('routeChangeStart', hideContent);
            router.events.off('routeChangeComplete', authCheck);
        }
    }, []);

    function authCheck(url) {
        // redirect to login page if accessing a private page and not logged in 
		const loginPath = '/user/login';
		const publicPaths = [loginPath];

        const path = url.split('?')[0];
        if (!userService.userValue && !publicPaths.includes(path)) {
            setAuthorized(false);
            router.push({
                pathname: '/user/login',
                query: { returnUrl: router.asPath }
            });
        } else {
            setAuthorized(true);
        }
    }

	const isLoginPage = router.pathname.startsWith(`/user`);

    const LayoutComponent = isLoginPage ? LoginLayout : Layout;

	return (
		<LayoutComponent>
			{loading ? (
				<Loading />
			) : (
				<div className="app-container bg-light">
					{/* <Nav /> */}
					<div className="hero-body is-align-items-flex-start">
					{
						authorized &&
						<Component {...pageProps} />
					}
					</div>
				</div>
			)}
		</LayoutComponent>
	);
};

export default MyApp;
