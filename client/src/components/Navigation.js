import React from 'react';
import {Text, View} from 'react-native';

//NAvigationContainer is a component which manages our navigation tree and has navigation state.

import { NavigationContainer } from '@react-navigation/native';

//createNativeStackNavigator is a function that returns onject containing 2 propoerties: Screen and Navigator.
//Navigator should contain Screen elements as its children to define the configuration for routes.

import { createNativeStackNavigator } from '@react-navigation/native-stack';
import HomeScreen from '../screens/HomeScreen';
import LoginScreen from '../screens/LoginScreen';
import RegisterScreen from '../screens/RegisterScreen';

const Stack = createNativeStackNavigator();

const Navigation = () => {

    return (
       <NavigationContainer>
        <Stack.Navigator>
            
            <Stack.Screen name="Login" component={LoginScreen} options ={{headerShown: false}} />
            <Stack.Screen name="Register" component={RegisterScreen} options ={{headerShown: false}}/>
            <Stack.Screen name="Home" component={HomeScreen} />
        </Stack.Navigator>
       </NavigationContainer>
    )

}

export default Navigation;