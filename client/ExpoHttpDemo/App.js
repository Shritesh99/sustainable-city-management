import React, { useState } from "react";
import {
  StyleSheet,
  Text,
  View,
  TouchableOpacity,
  TextInput,
  ScrollView,
  SafeAreaView,
  KeyboardAvoidingView,
} from "react-native";

export default function App() {
  let [getData, setGetData] = useState("");
  let [postData, setPostData] = useState("");
  const [userId, setUserId] = useState("");
  const [firstName, setFirstName] = useState("");
  const [lastName, setLastName] = useState("");

  var host = "172.20.10.4";
  var port = ":8080";
  // Get Request
  const getDataUsingGet = () => {
    getUrl = "http://" + host + port + "/user/" + userId;
    fetch(getUrl, {
      method: "GET",
    })
      .then((response) => response.json())
      // if response data is json, success
      .then((responseJson) => {
        // success
        setGetData(JSON.stringify(responseJson));
        console.log(responseJson);
      })
      // if response data is not json then alert error
      .catch((error) => {
        alert(JSON.stringify(error));
        console.error(error);
      });
  };

  const getDataUsingPost = () => {
    // POST data

    // POST request
    postUrl = "http://" + host + port + "/user/create";
    fetch(postUrl, {
      method: "POST",
      headers: {
        Accept: "application/json",
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        firstName: firstName,
        lastName: lastName,
      }),
    })
      .then((response) => response.json())
      // if response is in json then in success
      .then((responseJson) => {
        setPostData(JSON.stringify(responseJson));
        console.log(responseJson);
      })
      // if response is not json then error
      .catch((error) => {
        alert(JSON.stringify(error));
        console.error(error);
      });
  };

  return (
    <View style={styles.container}>
      <KeyboardAvoidingView behavior="padding" keyboardVerticalOffset={100}>
        <Text style={styles.labelStyle}>Input userId to Query</Text>
        <TextInput
          value={userId}
          onChangeText={(userId) => setUserId(userId)}
          placeholder={"userId"}
          style={styles.input}
        />
        {/* running GET Request */}
        <TouchableOpacity style={styles.buttonStyle} onPress={getDataUsingGet}>
          <Text style={styles.textStyle}>Query User Data (GET)</Text>
        </TouchableOpacity>

        <Text style={styles.responseData}>{getData}</Text>

        <Text style={styles.labelStyle}>{"\n\n\n"}Create a new User</Text>
        <TextInput
          style={styles.input}
          onChangeText={(firstName) => setFirstName(firstName)}
          value={firstName}
          placeholder="FirstName"
        />
        <TextInput
          style={styles.input}
          onChangeText={(lastName) => setLastName(lastName)}
          value={lastName}
          placeholder="lastName"
        />
        {/* running POST Request */}
        <TouchableOpacity style={styles.buttonStyle} onPress={getDataUsingPost}>
          <Text style={styles.textStyle}>Create User (POST)</Text>
        </TouchableOpacity>
        <Text style={styles.responseData}>{postData}</Text>
      </KeyboardAvoidingView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "white",
    justifyContent: "center",
    alignItems: 'center',
    padding: 20,
  },
  textStyle: {
    fontSize: 18,
    color: "white",
  },
  labelStyle: {
    fontSize: 18,
    color: "#008B00",
    justifyContent: "center",
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
  responseData: {
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
  input: {
    height: 40,
    margin: 12,
    borderWidth: 1,
    padding: 10,
  },
});
