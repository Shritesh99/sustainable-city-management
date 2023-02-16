import React , {createContext} from 'react';
import { BASE_URL } from '../config';
import axios from 'axios';


export const AuthContext= createContext();
//Something goes into the {children}
export const AuthProvider = ({children}) => {
//axios.post {BASE URL} testing
    const register = (name, email, password) => {
        axios.post(`${BASE_URL}/register`, {
            name, email, password,
        }).then(response => {
            //get the userdata for testing
            let userInfo = response.data
            console.log(userInfo)

        }).catch(error => {
            console.log(`register error ${error}`)
        })
    }
    const getfiletest = () =>{useEffect(() => {
        axios.get(`${BASE_URL}`).then(response => {
            console.log("Getting From::::", response.data)
        }).catch(error => console.log(error))},[])
    }
    return (
        <AuthContext.Provider value ='test'>{children}</AuthContext.Provider>
    )
    
}