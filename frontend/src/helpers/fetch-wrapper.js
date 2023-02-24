import getConfig from 'next/config';

import { userService } from '../services';

const { publicRuntimeConfig } = getConfig();

export const fetchWrapper = {
    get,
    post,
    put,
    delete: _delete
};

function get(url) {
    const requestOptions = {
        method: 'GET',
        headers: authHeader(url),
        // credentials: 'include'
    };
    return fetch(url, requestOptions).then(handleResponse);
}

function post(url, body) {
    const requestOptions = {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', ...authHeader(url) },
        // credentials: 'include',
        body: JSON.stringify(body)
    };
    console.log({
        msg: "fetch post",
        requestOptions : JSON.stringify(requestOptions),
        url: url,
    })
    return fetch(url, requestOptions).then(handleResponse);
}

function put(url, body) {
    const requestOptions = {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json', ...authHeader(url) },
        // credentials: 'include',
        body: JSON.stringify(body)
    };
    return fetch(url, requestOptions).then(handleResponse);    
}

// prefixed with underscored because delete is a reserved word in javascript
function _delete(url) {
    const requestOptions = {
        method: 'DELETE',
        // credentials: 'include',
        headers: authHeader(url)
    };
    return fetch(url, requestOptions).then(handleResponse);
}

// helper functions

function authHeader(url) {
    // return auth header with jwt if user is logged in and request is to the api url
    const user = userService.userValue;
    const isLoggedIn = user && user.Token;
    const isApiUrl = url.startsWith(publicRuntimeConfig.apiUrl);
    if (isLoggedIn && isApiUrl) {
        // console.log({'authHeader -> user.Token': user.Token});
        return { Token: `${user.Token}` };
    } else {
        return {};
    }
}

function handleResponse(response) {
    return response.text().then(text => {
        console.log({"response text": text});
        const data = text && JSON.parse(text);
        
        const user = userService.userValue;
        const isLoggedIn = user && user.Token;

        if (!response.ok && isLoggedIn) {
            if ([401, 403].includes(response.status) && userService.userValue) {
                // auto logout if 401 Unauthorized or 403 Forbidden response returned from api
                userService.logout(user.username);
            }

            const error = (data && data.msg) || response.statusText;
            return Promise.reject(error);
        }

        if ([500].includes(response.status)) {
            const error = "Internal Server Error, Please try again";
            return Promise.reject(error);
        }

        if(data.error) {
            const error = data && data.msg;
            return Promise.reject(error);
        }

        return data;
    });
}