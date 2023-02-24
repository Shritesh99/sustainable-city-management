//I want to use this AutoContext, but It doesn't work.  
//  <AuthContext.Provider value = {{register}}>{children}</AuthContext.Provider>
// use an array instead? what does it mean?
//require('dotenv').config()
import React , {useState, createContext} from 'react';
import { BASE_URL } from '../config';
import axios from 'axios';
import AsyncStorage from '@react-native-async-storage/async-storage'
//import BcryptReactNative from 'bcrypt-react-native';
import * as Crypto from 'expo-crypto';

export const AuthContext= createContext(); //This will going to export in LoginScreen RegisterScreen for POST

//Something send into the {children} component
export const AuthProvider = ({children}) => {
    const [userInfo, setUserInfo] = useState({});     //userInfo will going to another component. be ready.
    const [isLoading, setIsLoading] = useState(false);  //isLoading as well.
    //const bcrypt = require('bcryptjs') // hash + salt
 
    //Registration part
        //(first_name,last_name,username, password, role_id)
    const register = async (first_name,last_name, username, password, role_id) => {
        setIsLoading(true)
        //const hash = await Crypto.digestStringAsync(Crypto.CryptoDigestAlgorithm.SHA256,`${password}`)
        const reqBody = {
            "first_name" : first_name,
            "last_name" : last_name,
            "username" : username,
            "password" : password,
            "role_id" : role_id

        }
        console.log(reqBody)
        const registerAPI = "https://scm-backend.rxshri99.live/auth/register"
        axios.post(registerAPI,
        reqBody)
        .then(response => {
            let userInfo = response.data //save the user data into userInfo.
            setUserInfo(userInfo) //Change the userinfo by using setUserInfo
            AsyncStorage.setItem('userInfo', JSON.stringify(userInfo))  // JSON format?
            setIsLoading(false)
            console.log(userInfo)  //show on the console.
        })
        .catch(e => {console.log(`register error ${e}`)
        setIsLoading(false)})
        }


    const hashedlogin =  async (username, password) => {
        setIsLoading(true) // Yes, Now it is loading
        // http://server/auth/login
        

        await axios.post("https://scm-backend.rxshri99.live/auth/login",
        {username, password})
        .then(response => {
            let userInfo = response.data
            setUserInfo(userInfo) // ?
            AsyncStorage.setItem('userInfo', JSON.stringify(userInfo))
            //const accessToken = jwt.sign(userInfo,process.env.ACCESS_TOKEN_SECRET)
            // res.json({accessToken: accessToken})
            setIsLoading(false)
            console.log(userInfo)
        })
        .catch(e => {
            
            console.log(`register error ${e}`)
            setIsLoading(false)})
    }


    //Login part with JWT authentication
    const login = async (email, password) => {
    
        setIsLoading(true) // Yes, Now it is loading
        await axios.post('http://10.0.2.2:5000/api',{email, password}, {withCredentials:true})
        .then(response => {
            let userInfo = response.data
            setUserInfo(userInfo) // ?
            AsyncStorage.setItem('userInfo', JSON.stringify(userInfo))
            setIsLoading(false)
            console.log(userInfo)
        })
        .catch(e => {
            
            console.log(`register error ${e}`)
            setIsLoading(false)})
    }

    //Logout
    const logout = () => {
        setIsLoading(true)
        axios.post(`${BASE_URL}`, {},
        {
            headers: {Authorization: `Bearer ${userInfo.accessToken}`},
        },
        ).then(res => {
            console.log(res.data)
            AsyncStorage.removeItem('userInfo')
            setUserInfo({})
            setIsLoading(false)
        }). catch(e => {
            console.log(`logout error ${e}`)
            setIsLoading(false)
        })
    }

    //Check out logged in or not
    const isLoggedIn = async () => {
        try {
            let userInfo = await AsyncStorage.getItem('userInfo')
            userInfo = JSON.parse(userInfo)

            if(userInfo) {
                setUserInfo(userInfo)
            }
        }catch(e) {}
    }

    return (
        <AuthContext.Provider value = {{logout,hashedlogin,isLoading, userInfo, register, login}}>{children}</AuthContext.Provider>
    );
    
}

