import { Circles } from "react-loader-spinner";

export const Loading = () => (
	<div className="hero-body">
		<Circles
			height="50"
			width="50"
			color="#00d1b2"
			ariaLabel="circles-loading"
			wrapperStyle={{}}
			wrapperClass="container is-justify-content-center"
			visible={true}
		/>
	</div>
);
