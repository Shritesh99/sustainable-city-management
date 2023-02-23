import React, {useEffect, useState} from 'react';
import axios from 'axios';
 
import {Text, View} from 'react-native';
import Navigation from './src/components/Navigation';
import {AuthProvider} from './src/context/AuthContext'
//This is the Entry of the Application
const App = () => {
    const [backendData, setBackendData] = useState([])
    useEffect(()=>{
        async function getData(){
            try{
                const backendData = await axios.get("http://10.0.2.2:3000/test",{},{
                
                  
                })
                
                console.log(backendData.data)
            }
            catch(error){
                console.log(error)
            }
        }
        getData()
            }, [])

    return (
    
    <AuthProvider><Navigation /></AuthProvider> 
     ) 
    
    

}

export default App;