import { BehaviorSubject } from 'rxjs';
import getConfig from 'next/config';
import Router from 'next/router'

import { fetchWrapper } from '../helpers';

const { publicRuntimeConfig } = getConfig();
const baseUrl = `${publicRuntimeConfig.apiUrl}/user`;

// https://stackoverflow.com/questions/49411796/how-do-i-detect-whether-i-am-on-server-on-client-in-next-js
const userSubject = new BehaviorSubject(typeof window !== "undefined" && JSON.parse(localStorage.getItem('user')));

export const userService = {
    user: userSubject.asObservable(),
    get userValue () {
        console.log(userSubject.value)
        if (userSubject.value && (Date.now()/1000 > userSubject.value.expires)) {
            // token expired
            console.log("token expired")
            localStorage.removeItem('user');
            userSubject.next(null);
            return null;
        }
        return userSubject.value 
    },
    register,
    login,
    logout,
    getAll
};

// FirstName string `json:"first_name"`
// LastName  string `json:"last_name"`
// RoleID    int32  `json:"role_id"`
// Username     string `json:"username"`
// Password  string `json:"password"`

function register(firstName, lastName, username, password, roleId) {
    console.log({
        msg: "register fuction",
        username: username,
        password: password,
    });

    const reqBody = {
        "first_name": firstName,
        "last_name": lastName,
        "role_id": roleId,
        "username": username,
        "password": password
    }

    return fetchWrapper.post(`${baseUrl}/register`, reqBody)
        .then(resp => {
            // publish user to subscribers and store in local storage to stay logged in between page refreshes
            console.log({"register":JSON.stringify(resp)});
            // userSubject.next(user);
            // localStorage.setItem('user', JSON.stringify(user));

            return resp;
        });
}

function login(username, password) {
    console.log({
        msg: "login fuc",
        username: username,
        password: password,
    });
    return fetchWrapper.post(`${baseUrl}/login`, { username, password })
        .then(user => {
            // publish user to subscribers and store in local storage to stay logged in between page refreshes
            console.log(JSON.stringify(user));
            userSubject.next(user);
            localStorage.setItem('user', JSON.stringify(user));

            return user;
        });
}

function logout() {
    // remove user from local storage, publish null to user subscribers and redirect to login page
    fetchWrapper.get(`${baseUrl}/logout`)
    localStorage.removeItem('user');
    userSubject.next(null);
    Router.push('/user/login');
}

function getAll() {
    return userSubject.value;
}
