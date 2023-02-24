import React, {useContext, useState} from 'react';
import {Button,Text,TextInput,TouchableOpacity,View,StyleSheet,} from 'react-native';
import Spinner from 'react-native-loading-spinner-overlay';
import {AuthContext} from '../context/AuthContext'
import {SelectList} from 'react-native-dropdown-select-list'
 
//Beginning of RegisterScreen
const RegisterScreen = ({navigation}) => {
  const [first_name, setFirstname] = useState(null);
  const [last_name, setLastname] = useState(null);
  const [username, setUsername] = useState(null);
  const [password, setPassword] = useState(null);
  const [role_id, setRoleid] = useState("");
  
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const data = [
    {key: 1, value:'Bus'},
    {key: 4, value:'Car'},
     
    
  ]
  // Get this function from the AuthContext.
  // But it does not define in this js
  const {isLoading, register} = useContext(AuthContext) //Get from AuthoContext
  
  return (
    <View style={styles.container}>
      <Spinner visible ={isLoading} />

      <View style={styles.wrapper}>
       {/*val = {} zzz This was bug*/}
      
        <TextInput
          style={styles.input}
          value={first_name}
          placeholder="Enter first name"
          onChangeText={text => setFirstname(text)}
        />

        <TextInput
          style={styles.input}
          value={last_name}
          placeholder="Enter last name"
          onChangeText={text => setLastname(text)}
        />

        <TextInput
          style={styles.input}
          value={username}
          placeholder="Enter email"
          onChangeText={text => setUsername(text)}
        />

        <TextInput
          style={styles.input}
          value={password}
          placeholder="Enter password"
          onChangeText={text => setPassword(text)}
          secureTextEntry
        />

        <SelectList 
          value={data}
          style={{flexDirection: 'row', marginTop: 20}}
          search ={false}
          setSelected = {(val) => setRoleid(val)}
          data = {data}
          placeholder ={"Select Category"}
          defaultOption = {{key: 1, value:'Bus'}}
        />
      
        <Button
          title="Register"
          onPress={() => {
            register(first_name,last_name,username, password, role_id),
            navigation.navigate('Login')
          }
            }
        />

        <View style={{flexDirection: 'row', marginTop: 20}}>
          <Text>Already have an account? </Text>
          <TouchableOpacity onPress={() => navigation.navigate('Login')}>
            <Text style={styles.link}>Login</Text>
          </TouchableOpacity>
        </View>
      </View>
    </View>
  );
}; 

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  wrapper: {
    width: '80%',
  },
  input: {
    marginBottom: 12,
    borderWidth: 1,
    borderColor: '#bbb',
    borderRadius: 5,
    paddingHorizontal: 14,
  },
  link: {
    color: 'blue',
  },
});

export default RegisterScreen;