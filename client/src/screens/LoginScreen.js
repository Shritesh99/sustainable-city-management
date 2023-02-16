import React, { useContext, useState } from 'react';
import {TextInput, Button, TouchableOpacity, Text, View, StyleSheet} from 'react-native';
import {AuthContext} from '../context/AuthContext';

//get the Navigation.js into LoginScreen Function.
//Through {navigation}
//onPress => navigation to Register
const LoginScreen = ({navigation}) => {
    // Input data on the textInput
    const [email, setEmail] = useState(null)
    const [password, setPassword] = useState(null)
    const val = useContext(AuthContext); //test
    return (
        <View style={styles.container}>
            <Text>Sign In</Text>
            <View style={styles.wrapper}>
                <Text>{val}</Text>
                <TextInput style ={styles.input} value = {email} placeholder="Email Address" onChangeText ={text => setEmail(text)}/>
                <TextInput style ={styles.input} value = {password} placeholder="password" onChangeText ={text => setPassword(text)} secureTextEntry />

                <Button title="Sign In" />
                <View style={{FlexDirection: 'row' , marginTop:30}}>
                    <Text>Don't haaasffffffsveffff affffffn account? </Text>
                    <TouchableOpacity onPress= {() => navigation.navigate('Register')}>
                        <Text style = {styles.link}>Sign Up</Text>
                    </TouchableOpacity>
                    <TouchableOpacity onPress= {() => navigation.navigate('Home')}>
                        <Text style = {styles.link}>[Test]To home</Text>
                    </TouchableOpacity>
                </View>
            </View>
        </View>
    )

}

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