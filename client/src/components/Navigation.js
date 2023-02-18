
import {Text, View} from 'react-native';
import React, { useContext, useState } from 'react';
//NAvigationContainer is a component which manages our navigation tree and has navigation state.
import { NavigationContainer } from '@react-navigation/native';
//createNativeStackNavigator is a function that returns onject containing 2 propoerties: Screen and Navigator.
//Navigator should contain Screen elements as its children to define the configuration for routes.
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import HomeScreen from '../screens/HomeScreen';
import LoginScreen from '../screens/LoginScreen';
import RegisterScreen from '../screens/RegisterScreen';
import {AuthContext} from '../context/AuthContext';
 
const Stack = createNativeStackNavigator();
 
const Navigation = () => {
    const {userInfo} = useContext(AuthContext)
     

    return (
       <NavigationContainer>
        <Stack.Navigator>
            {userInfo.access_token ? (
            <Stack.Screen name="Home" component={HomeScreen} />
            ) :( <>
                <Stack.Screen name="Login" component={LoginScreen} options ={{headerShown: false}} />
                <Stack.Screen name="Register" component={RegisterScreen} options ={{headerShown: false}}/>
                </>)}
      
        </Stack.Navigator>
       </NavigationContainer>
    )

}

export default Navigation;