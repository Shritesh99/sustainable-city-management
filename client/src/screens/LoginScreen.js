import React, { useContext, useState } from 'react';
import {TextInput, Button, TouchableOpacity, Text, View, StyleSheet} from 'react-native';
import {AuthContext} from '../context/AuthContext';
import Spinner from 'react-native-loading-spinner-overlay'
 
//Through {navigation}
//onPress => navigation to Register
const LoginScreen = ({navigation}) => {
    // Input data on the textInput
    // Nothing is in the email as a default
    const [username, setUsername] = useState(null)
    const [password, setPassword] = useState(null)
    // Just string values are comes from the Context but {register} function can not come over.
    //const valueFromAuthContext = useContext(AuthContext); //this value comes from AuthContext
    const {isLoading, hashedlogin} = useContext(AuthContext) //Get from AuthoContext
    
    return (
        
        <View style={styles.container}>
            <Spinner visible ={isLoading} />
            <Text>Sign In</Text>
            <View style={styles.wrapper}>
                
               
                <TextInput style ={styles.input} value = {username} placeholder="Email Address" onChangeText ={text => setUsername(text)}/>
                <TextInput style ={styles.input} value = {password} placeholder="password" onChangeText ={text => setPassword(text)} secureTextEntry />
                <Button  title="Sign In" onPress={() => {hashedlogin(username, password)}}/>
          
               
                <View style={{FlexDirection: 'row' , marginTop:30}}>
                    <Text>Don't have an account? </Text>
                    <TouchableOpacity onPress= {() => navigation.navigate('Register')}>
                        <Text style = {styles.link}>Sign Up</Text>
                    </TouchableOpacity>
                  
                </View>
            </View>
        </View>
    )

}
/*
Login request:"serverurl"/user/login Body : {"username": xyz,}
*/
// Cover the whole page : container
// wrapper for width 
// input for textinput and sign in button
const styles = StyleSheet.create({
    container: {
        flex: 1,
        alignItems: 'center',
        justifyContent: 'center',

    },
    wrapper: {
        width: '80%',
    },
    input : {
        marginBottom : 15,
        borderWidth: 2,
        borderColor: '#bbb',
        borderRadius: 5,
        paddinHorizontal: 14,
    },
    link: {
        color : 'blue',

    }
})

export default LoginScreen;
 