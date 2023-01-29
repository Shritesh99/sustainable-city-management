import React, { useState } from "react";
import { StyleSheet, Text, View, TouchableOpacity } from "react-native";

export default function App() {
  let [apiData, setApiData] = useState('');

  // Get Request
  const getDataUsingGet = () => {
    fetch('https://jsonplaceholder.typicode.com/posts/1', {
      method: 'GET',
    })
    .then((response) => response.json())
    // if response data is json, success
    .then((responseJson) => {
      // success
      setApiData(JSON.stringify(responseJson));
      console.log(responseJson);
    })
    // if response data is not json then alert error
    .catch((error) => {
      alert(JSON.stringify(error));
      console.error(error)
    });
  };

  const getDataUsingPost = () => {
    // POST data
    var jsonSend = {};
    var formBody = [];
    for(var key in jsonSend) {
      var encodedKey = encodeURIComponent(key);
      var encodedValue = encodeURIComponent(jsonSend[key]);
      formBody.push(encodedKey + '=' + encodedValue);
    }
    formBody = formBody.join('&');
    // POST request
    fetch('https://jsonplaceholder.typicode.com/posts', {
      method: 'POST',
      body: formBody,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
      },
    })
    .then((response) => response.json())
    // if response is in json then in success
    .then((responseJson) => {
      setApiData(JSON.stringify(responseJson));
      console.log(responseJson);
    })
    // if response is not json then error
    .catch(error => {
      alert(JSON.stringify(error));
      console.error(error);
    });
  };

    return (
        <View style={styles.container}>
            <Text style={styles.apiData}>{apiData}</Text>
            {/* running GET Request */}
            <TouchableOpacity
                style={styles.buttonStyle}
                onPress={getDataUsingGet}>
                <Text style={styles.textStyle}>Get Data Using GET</Text>
            </TouchableOpacity>
            {/* running POST Request */}
            <TouchableOpacity
                style={styles.buttonStyle}
                onPress={getDataUsingPost}>
                <Text style={styles.textStyle}>Get Data Using POST</Text>
            </TouchableOpacity>  
        </View>
    );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "white",
    justifyContent: "center",
    padding: 20,
  },
  textStyle: {
    fontSize: 18,
    color: "white",
  },
  buttonStyle: {
    alignItems: "center",
    backgroundColor: "#008B00",
    padding: 10,
    marginVertical: 10,
  },
  buttonText: {
    color: "#fff",
  },
  apiData: {
    fontSize: 17,
    textAlign: "center",
    fontStyle: "italic",
  },
  dataContainer: {
    marginHorizontal: 20,
    backgroundColor: "#fff",
    padding: 10,
    borderRadius: 5,
  },
});
