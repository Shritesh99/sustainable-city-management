import { useContext, useState } from "react";
import { createNativeStackNavigator } from "@react-navigation/native-stack";
import HomeScreen from "../screens/HomeScreen";
import LoginScreen from "../screens/LoginScreen";
import RegisterScreen from "../screens/RegisterScreen";
import { AuthContext } from "../context/AuthContext";
import { NavigationContainer } from "@react-navigation/native";
import {
  MaterialIcons,
  Text,
  Stack,
  Pressable,
  Input,
  Box,
  Link,
  Button,
  NativeBaseProvider,
  VStack,
} from "native-base";
export default function Navigation() {
  const Stack = createNativeStackNavigator();
  //const { userInfo } = useContext(AuthContext);

  //Accessing with accessToken
  return (
    <NativeBaseProvider>
      <NavigationContainer>
        <Stack.Navigator>
          <Stack.Screen name="Home" component={HomeScreen} />
          <Stack.Screen name="Login" component={LoginScreen} />
        </Stack.Navigator>
      </NavigationContainer>
    </NativeBaseProvider>
  );
}
