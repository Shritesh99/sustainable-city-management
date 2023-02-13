import { Head } from "./Head";
import { Header } from "./Header";
import Copyright from './Copyright';

export const Layout = ({ children }) => {
	return (
		<section className="hero is-fullheight">
			<Head />
			<Header />
			{children}
			<Copyright />
		</section>
	);
};
