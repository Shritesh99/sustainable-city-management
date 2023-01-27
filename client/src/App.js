import { StatusBar } from "expo-status-bar";
import { Text, View } from "react-native";

import * as NavigationBar from "expo-navigation-bar";
export default function MyApp() {
	const visibility = NavigationBar.useVisibility();
	return (
		<View>
			{/* <NavigationBar></NavigationBar> */}
			<Text style={{ alignItems: "center" }}>
				Sustinable City Management
			</Text>
			<StatusBar style="auto" />
		</View>
	);
}
