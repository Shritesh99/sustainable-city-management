// In here just calling the HomeScreen, LoggindScreen.....
import { useEffect, useState, useContext } from "react";
import Navigation from "./src/components/Navigation";
import { AuthProvider } from "./src/context/AuthContext";
import LoginScreen from "./src/screens/LoginScreen";
import { LoggedInScreen } from "./src/screens/LoggedInScreen";
import { RegisterScreen } from "./src/screens/RegisterScreen";
import React from "react";
import { AuthContext } from "./src/context/AuthContext";
import { FontAwesome } from "@expo/vector-icons";
import { Feather } from "@expo/vector-icons";

import { Ionicons } from "@expo/vector-icons";
import {
  NativeBaseProvider,
  Text,
  Box,
  Button,
  StatusBar,
  HStack,
  IconButton,
  Icon,
  Parse,
  MaterialIcons,
} from "native-base";
import { createBottomTabNavigator } from "@react-navigation/bottom-tabs";
import { NavigationContainer } from "@react-navigation/native";
import { createNativeStackNavigator } from "@react-navigation/native-stack";
import { createDrawerNavigator } from "@react-navigation/drawer";
import HomeScreen from "./src/screens/HomeScreen";
const Tab = createBottomTabNavigator();

function DetailsScreen() {
  return <Text>Details Screen</Text>;
}

//Tab Bar.
function MyTabsScreen() {
  return (
    <Tab.Navigator
      initialRouteName="Home"
      screenOptions={({ route }) => ({
        tabBarIcon: ({ focused, color, size }) => {
          let iconName;
          if (route.name === "HomeScreen") {
            iconName = focused ? "home" : "home-outline";
          } else if (route.name === "RegisterScreen") {
            iconName = focused ? "person-circle" : "person-circle-outline";
          } else if (route.name === "LoginScreen") {
            iconName = focused ? "enter" : "enter-outline";
          }

          // You can return any component that you like here!
          return <Ionicons name={iconName} size={size} color={color} />;
        },
        tabBarActiveTintColor: "indigo",
        tabBarInactiveTintColor: "gray",
      })}
    >
      <Tab.Screen name="HomeScreen" component={LoggedInScreen} />
      <Tab.Screen name="Details" component={DetailsScreen} />
      <Tab.Screen name="LoginScreen" component={LoginScreen} />
      <Tab.Screen name="RegisterScreen" component={RegisterScreen} />
    </Tab.Navigator>
  );
}
//const { isl } = useContext(AuthContext);
const Stack = createNativeStackNavigator();
const Drawer = createDrawerNavigator();

export default function App({ navigation }) {
  return (
    <AuthProvider>
      <NativeBaseProvider>
        <NavigationContainer>
          <MyTabsScreen />
        </NavigationContainer>
      </NativeBaseProvider>
    </AuthProvider>
  );
}
