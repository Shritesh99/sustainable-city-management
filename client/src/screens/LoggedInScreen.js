import React, { FC, ReactElement, useEffect, useState } from "react";
import { Text, View } from "react-native";
import { useContext } from "react";
import { AuthContext } from "../context/AuthContext";

export const LoggedInScreen = ({ navigation, route }) => {
  // State variable that will hold username value

  const { userInfo } = useContext(AuthContext); //Get from AuthoContext
  React.useEffect(() => {
    if (route.params?.post) {
      //send post to the server
    }
  }, [route.params?.post]);

  return (
    <View>
      <Text>Am I connected? YES Post Hi : {route.params?.post}</Text>
    </View>
  );
};
