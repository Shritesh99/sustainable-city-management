//I want to use this AutoContext, but It doesn't work yet. need to figure it out.
// Need to check CreateContext.

import React , {createContext} from 'react';
// import { BASE_URL, JSONURL } from '../config';
import axios from 'axios';
export const AuthContext= createContext();
//Something goes into the {children}
export const AuthProvider = ({children}) => {

    const register = (name, email, password, data) =>{
        axios.post('https://jsonplaceholder.typicode.com/todos', {name, email, password, data})
        .then(res => {
            let userInfo = res.data
            console.log(userInfo)
            return userInfo})
        .catch(e => {console.log(`register error ${e}`)})
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

    return (
        <AuthContext.Provider value = 'test'>{children}</AuthContext.Provider>
    );
    
}
