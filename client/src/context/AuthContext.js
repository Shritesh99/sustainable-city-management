//I want to use this AutoContext, but It doesn't work.  
//  <AuthContext.Provider value = {{register}}>{children}</AuthContext.Provider>
// use an array instead? what does it mean?

import React , {useState, createContext} from 'react';
import { BASE_URL } from '../config';
import axios from 'axios';
import AsyncStorage from '@react-native-async-storage/async-storage'


export const AuthContext= createContext(); //This will going to export in LoginScreen RegisterScreen for POST

//Something send into the {children} component
export const AuthProvider = ({children}) => {
    const [userInfo, setUserInfo] = useState({});     //userInfo will going to another component. be ready.
    const [isLoading, setIsLoading] = useState(false);  //isLoading as well.
    
    
    const register =(name, email, password, category) => {
        setIsLoading(true)
        axios.post(`${BASE_URL}`,{name,email, password,category})
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

    const login =(email, password) => {
        
        setIsLoading(true) // Yes, Now it is loading
        axios.post(`${BASE_URL}`,{email, password})
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

    const logout = () => {
        setIsLoading(true)
    }

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
        <AuthContext.Provider value = {{isLoading, userInfo, register, login}}>{children}</AuthContext.Provider>
    );
    
}
