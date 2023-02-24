 
import React, {useContext} from 'react';
import {AuthContext} from '../context/AuthContext';
import MapView from 'react-native-maps';
import { StyleSheet,Text, View } from 'react-native';
const TestScreen = () => {
  //Get the userInfo
  const {userInfo } = useContext(AuthContext)
    return (
     
      <View style={styles.container}>
          <Text>TEST for map {userInfo.email}</Text>
      <MapView style={styles.map} />
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
});
export default TestScreen;