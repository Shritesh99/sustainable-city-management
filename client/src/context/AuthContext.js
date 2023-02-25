import React, { useState, createContext } from "react";
import { BASE_URL } from "../config";
import axios from "axios";
import AsyncStorage from "@react-native-async-storage/async-storage";

export const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
  const [userInfo, setUserInfo] = useState({});
  const [isLoggedin, setIsLoggedin] = useState(false); //isLoading as well.

  //(first_name,last_name,username, password, role_id)
  const register = async (
    first_name,
    last_name,
    username,
    password,
    role_id
  ) => {
    //setIsLoggedin(true);
    const reqBody = {
      first_name: first_name,
      last_name: last_name,
      username: username,
      password: password,
      role_id: 1,
    };
    console.log(reqBody);
    const registerAPI = "https://scm-backend.rxshri99.live/auth/register";
    axios
      .post(registerAPI, reqBody)
      .then((response) => {
        let userInfo = response.data; //get the data from the server.
        setUserInfo(userInfo); //Change the userinfo by using setUserInfo
        AsyncStorage.setItem("userInfo", JSON.stringify(userInfo));
        //setIsLoading(false);
        console.log(userInfo); //show on the console.
      })
      .catch((e) => {
        console.log(`register error ${e}`);
        //setIsLoading(false);
      });
  };
  //login
  //When successfully login, change the isLoggedin to true. (default = false)
  const hashedlogin = async (username, password) => {
    await axios
      .post("https://scm-backend.rxshri99.live/auth/login", {
        username,
        password,
      })
      .then((response) => {
        let userInfo = response.data;
        setUserInfo(userInfo);
        AsyncStorage.setItem("userInfo", JSON.stringify(userInfo));
        // const userInfoJson = JSON.stringify(userInfo);
        const token = userInfo["Token"];
        console.log(token);
        setIsLoggedin(true);
        console.log(userInfo);
      })
      .catch((e) => {
        console.log(`register error ${e}`);
        setIsLoggedin(false);
      });
  };

  //Logout
  const logout = () => {
    setIsLoggedin(true);
    axios
      .post(
        `${BASE_URL}`,
        {},
        {
          headers: { Authorization: `Bearer ${userInfo.jwtToken}` },
        }
      )
      .then((res) => {
        console.log(res.data);
        AsyncStorage.removeItem("userInfo");
        setUserInfo({});
        setIsLoggedin(false);
      })
      .catch((e) => {
        console.log(`logout error ${e}`);
        setIsLoggedin(true);
      });
  };

  /*
  //Check out logged in or not
  const isLoggedIn = async () => {
    try {
      let userInfo = await AsyncStorage.getItem("userInfo");
      userInfo = JSON.parse(userInfo);

      if (userInfo) {
        setUserInfo(userInfo);
      }
    } catch (e) {}
  };
*/
  //Sending these values to children.
  return (
    <AuthContext.Provider
      value={{ logout, hashedlogin, isLoggedin, userInfo, register }}
    >
      {children}
    </AuthContext.Provider>
  );
};
