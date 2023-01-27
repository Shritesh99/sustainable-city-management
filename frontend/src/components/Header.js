import Link from "next/link";
export const Header = () => (
	<div className="hero-head">
		<header className="navbar has-background-primary">
			<div className="container">
				<div className="navbar-brand">
					<Link
						href="/"
						shallow={true}
						className="navbar-item has-text-primary-light">
						<p className="is-size-3">
							Sustinable City Management
						</p>
					</Link>
				</div>
			</div>
		</header>
	</div>
);
