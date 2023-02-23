 
import React, {useContext} from 'react';
import {Button, Text, View} from 'react-native';
import {AuthContext} from '../context/AuthContext';
 
const TestScreen = () => {

 
  //Get the userInfo
  const {userInfo } = useContext(AuthContext)

    return (
      <View>
      <Text>TEST for map {userInfo.email}</Text>
       
    </View>
    )
}
export default TestScreen;