import { Head } from "./Head";
import { Header } from "./Header";
import { Footer } from "./Footer";

export const Layout = ({ children }) => {
	return (
		<section className="hero is-fullheight">
			<Head />
			<Header />
			{children}
			<Footer />
		</section>
	);
};
