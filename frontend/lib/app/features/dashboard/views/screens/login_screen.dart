import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:sustainable_city_management/app/features/dashboard/views/screens/dashboard_screen.dart';
import 'package:sustainable_city_management/app/features/dashboard/views/screens/register_screen.dart';

// convert json -> object
// dart -> difficult to tranformation
// class -> object

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

//https://scm-backend.rxshri99.live/auth/login
// username , password
//https://jsonplaceholder.typicode.com/posts
class _LoginScreenState extends State<LoginScreen> {
  //text controllers

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

// It will connect with onTap bar.

  Future signIn() async {
    var dio = Dio();
    var response =
        //https://scm-backend.rxshri99.live/auth/login
        //Need you use this address above with 'username' , 'password' parameter.
        //I am using test URL right now.
        await dio.post('https://jsonplaceholder.typicode.com/posts', data: {
      'username': _emailController.text.trim(),
      'password': _passwordController.text.trim(),
    });

    var result = response.statusCode;

    return result;
  }

//Memory management
  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  //This will allow login and get token as well.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 25),
          Text('Hello Again',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              )),
          SizedBox(height: 10),
          Text('Welcome back',
              style: TextStyle(
                fontSize: 20,
              )),
          SizedBox(height: 70),
          //email

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Email',
                    )),
              ),
            ),
          ),
          SizedBox(height: 10),
          //password

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Password',
                    )),
              ),
            ),
          ),
          SizedBox(height: 10),
          //sign in button

          Container(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrationScreen()));
                },
                child: Text("Create Account?"),
              )),
          ElevatedButton(
            child: Text("Submit"),
            onPressed: () async {
              dynamic result = await signIn();
              if (result == 201) {
                //When you get the response.statusCode == 201 -> login.
                //Need to switch
                print('True');
                print(result);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DashboardScreen()));
              } else if (result == 200) {
                print('False');
                print(result);
                //Error in Toast  -- Ask to Per
                // Toast.show("Invalid Username or Password",
                //     duration: Toast.lengthShort, gravity: Toast.bottom);
                _emailController.text = "";
                _passwordController.text = "";
              }
            },
          ),
        ],
      ))),
    );
  }
}
