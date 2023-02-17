import React, {useContext, useState} from 'react';
import {Button,Text,TextInput,TouchableOpacity,View,StyleSheet,} from 'react-native';
import Spinner from 'react-native-loading-spinner-overlay';
import {AuthContext} from '../context/AuthContext'
import {SelectList} from 'react-native-dropdown-select-list'
import axios from 'axios';
import { BASE_URL, JSONURL } from '../config';
 
const getuser = () => {
  axios.get(JSONURL).then(res => {const persons = res.data})
} 

//testing
const AxiosToSendDdata =(name, email, password, category) => {
  axios.post('https://jsonplaceholder.typicode.com/todos',{name,email, password,category})
  .then(response => {
      let userInfo = response.data
      console.log(userInfo)
      return userInfo
  })
  .catch(e => {console.log(`register error ${e}`)})
  }

// Down list
const RegisterScreen = ({navigation}) => {
  const [name, setName] = useState(null);
  const [email, setEmail] = useState(null);
  const [password, setPassword] = useState(null);
  const [category, setCategory] = useState("");
 
  const data = [
    {key: '1', value:'Bus'},
    {key: '2', value:'Air'},
    {key: '3', value:'Bike'},
    {key: '4', value:'Test'},
    
  ]
  
  const val = useContext(AuthContext); //test

  //const {register} = useContext(AuthContext)
  
  return (
    <View style={styles.container}>

      
      <View style={styles.wrapper}>
      <Text>{val}</Text>
      
        <TextInput
          style={styles.input}
          value={name}
          placeholder="Enter name"
          onChangeText={text => setName(text)}
        />

        <TextInput
          style={styles.input}
          value={email}
          placeholder="Enter email"
          onChangeText={text => setEmail(text)}
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
          setSelected = {(val) => setCategory(val)}
          data = {data}
          placeholder ={"Select Category"}
          defaultOption = {{key: '1', value:'Bus'}}
        />
      
        <Button
        
          title="Register"
          onPress={() => {
            AxiosToSendDdata(name, email, password, category)
            }}
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
 