export const ErrorNotification = (props) => {
	return (
		<div class="notification is-danger is-light is-fullwidth m-1">
			<button class="delete" onClick={() => props.setErr("")}></button>
			{props.err
				? typeof props.err === "string"
					? props.err
					: props.err.message
				: "Invalid Error"}
		</div>
	);
};
