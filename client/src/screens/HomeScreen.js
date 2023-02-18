import React from 'react';
import MapView from 'react-native-maps';
import { Button, StyleSheet, View } from 'react-native';
import Spinner from 'react-native-loading-spinner-overlay'
const HomeScreen = () => {
  //Get the userInfo
  const {userInfo, isLoading } = useContext(AuthContext)

    return (
        <View style={styles.container}>
          <Spinner visible ={isLoading} />
          <Text style ={styles.welcome}>Welcome ! {userInfo.user.name}</Text>
          <Button title ='Logout' color= 'red' />
      
    </View>
    )

}

const styles = StyleSheet.create({
    container: {
      flex: 1,
    },
    map: {
      width: '100%',
      height: '100%',
    },
    welcome: {
      fontSize : 18,
      marginBottom: 8,
    }
  });

export default HomeScreen;