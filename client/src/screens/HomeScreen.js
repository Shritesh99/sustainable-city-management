 
import React, {useContext} from 'react';
import {Button, Text, View} from 'react-native';
import {AuthContext} from '../context/AuthContext';
 
const HomeScreen = () => {

 
  //Get the userInfo
  const {userInfo,logout } = useContext(AuthContext)

    return (
      <View>
      <Text>Welcome {userInfo.first_name}</Text>
      <Button title="Logout" color="red" onPress={logout} />
    </View>
    )
}
export default HomeScreen;