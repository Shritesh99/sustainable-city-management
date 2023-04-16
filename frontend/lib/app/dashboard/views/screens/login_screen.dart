import 'package:flutter/material.dart';
import 'package:sustainable_city_management/app/dashboard/views/screens/register_screen.dart';
import 'package:sustainable_city_management/app/services/user_services.dart';
import 'package:sustainable_city_management/app/dashboard/models/login_model.dart';

import 'package:get/get.dart';
import 'package:sustainable_city_management/app/config/routes/app_pages.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[300],
      body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 25),
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
                // color: Colors.grey[200],
                // border: Border.all(
                //   color: Colors.white,
                // ),
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
                // color: Colors.grey[200],
                // border: Border.all(
                //   color: Colors.white,
                // ),
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
            child: Text("Login"),
            onPressed: () async {
              LoginModel? result = await UserServices().login(
                  _emailController.text.trim(),
                  _passwordController.text.trim());

              if (result != null) {
                if (result.error) {
                  _emailController.text = "";
                  _passwordController.text = "";

                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text(
                              "Login Failed",
                            ),
                            content: Text(
                              result.msg,
                              style: TextStyle(color: Colors.black),
                            ),
                          )).then((val) {});
                  await Future.delayed(Duration(seconds: 2));
                  Navigator.of(context).pop(true);
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );

                  await Future.delayed(Duration(seconds: 2));
                  Navigator.pop(context);
                  Get.toNamed(Routes.dashboard);
                }
              }
            },
          ),
        ],
      ))),
    );
  }
}
