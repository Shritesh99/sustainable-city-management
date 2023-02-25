import React, { useContext } from "react";
import { Button, Text, View } from "react-native";
import { AuthContext } from "../context/AuthContext";
import { createDrawerNavigator } from "@react-navigation/drawer";
import { NavigationContainer } from "@react-navigation/native";
import {
  NativeBaseProvider,
  Box,
  StatusBar,
  HStack,
  IconButton,
  Icon,
  Parse,
  MaterialIcons,
} from "native-base";
//Bearer home screen.
export default function HomeScreen({ navigation }) {
  return (
    <View>
      <Text>Welcome </Text>
      <Text>Home Screen</Text>
    </View>
  );
}
