import React, {useEffect, useState} from 'react'; 
import {Text, View} from 'react-native';
import Navigation from './src/components/Navigation';
import {AuthProvider} from './src/context/AuthContext'
//This is the Entry of the Application
const App = () => {
    /*
    const [backendData, setBackendData] = useState([])
    useEffect(()=>{
        async function getData(){
            try{
                // 127.0.0.1/user/login
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
*/
    return (
    
    <AuthProvider><Navigation /></AuthProvider> 
     ) 
    
    

}

export default App;