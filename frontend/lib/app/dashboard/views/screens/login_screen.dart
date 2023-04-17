import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sustainable_city_management/app/config/routes/app_pages.dart';
import 'package:sustainable_city_management/app/controller/ui_controller.dart';
import 'package:sustainable_city_management/app/constants/app_constants.dart';
import 'package:sustainable_city_management/app/dashboard/models/login_model.dart';
import 'package:sustainable_city_management/app/services/user_services.dart';
import 'package:sustainable_city_management/app/shared_components/custom_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    UIController uiController = Get.find<UIController>();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > LargeScreenWidth) {
              return _buildLargeScreen(size, uiController);
            } else {
              return _buildSmallScreen(size, uiController);
            }
          },
        ),
      ),
    );
  }

  /// For large screens
  Widget _buildLargeScreen(
    Size size,
    UIController UIController,
  ) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 100, left: 60),
          child: Container(
            height: size.width * 0.4,
            width: size.width * 0.4,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  ImageRasterPath.coverImg,
                ),
                fit: BoxFit.fill,
              ),
              shape: BoxShape.rectangle,
            ),
          ),
        ),
        SizedBox(width: size.width * 0.06),
        Expanded(
          flex: 5,
          child: _buildMainBody(
            size,
            UIController,
          ),
        ),
      ],
    );
  }

  /// For Small screens
  Widget _buildSmallScreen(
    Size size,
    UIController uiController,
  ) {
    return Center(
      child: _buildMainBody(
        size,
        uiController,
      ),
    );
  }

  /// Main Body
  Widget _buildMainBody(
    Size size,
    UIController uiController,
  ) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: size.width > LargeScreenWidth
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            size.width > LargeScreenWidth
                ? Container()
                : Lottie.asset(
                    'assets/wave.json',
                    height: size.height * 0.2,
                    width: size.width,
                    fit: BoxFit.fill,
                  ),
            SizedBox(
              height: size.height * 0.03,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                'Sign In',
                style: kLoginTitleStyle(size),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                'Welcome Back',
                style: kLoginSubtitleStyle(size),
              ),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 20.0, right: size.width > LargeScreenWidth ? 80 : 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    /// user's Email
                    TextFormField(
                      style: kTextFormFieldStyle(),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        hintText: 'youremail@email.com',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                      controller: _emailController,
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (value.length < 4) {
                          return 'please enter valid email! At least enter 4 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),

                    /// password
                    Obx(
                      () => TextFormField(
                        style: kTextFormFieldStyle(),
                        controller: _passwordController,
                        obscureText: uiController.isObscure.value,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_open),
                          suffixIcon: IconButton(
                            icon: Icon(
                              uiController.isObscure.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              uiController.isObscureActive();
                            },
                          ),
                          hintText: 'Password',
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          } else if (value.length < 6) {
                            return 'at least enter 5 characters';
                          } else if (value.length > 13) {
                            return 'maximum character is 13';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),

                    /// Login Button
                    loginButton(),
                    SizedBox(
                      height: size.height * 0.03,
                    ),

                    /// Navigate To Register Screen
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.register);
                        _emailController.clear();
                        _passwordController.clear();
                        _formKey.currentState?.reset();
                        uiController.isObscure.value = true;
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'Don\'t have an account?',
                          style: kHaveAnAccountStyle(size),
                          children: [
                            TextSpan(
                              text: " Sign up",
                              style: kLoginOrSignUpTextStyle(
                                size,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void gotoDashboard() {
    Get.toNamed(Routes.dashboard);
  }

  // Login Button
  Widget loginButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(const Color(0xFF00296B)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        onPressed: () async {
          // Validate returns true if the form is valid, or false otherwise.
          if (_formKey.currentState!.validate()) {
            LoginModel? result = await UserServices().login(
                _emailController.text.trim(), _passwordController.text.trim());

            if (result != null) {
              if (result.error) {
                // _emailController.text = "";
                // _passwordController.text = "";
                CustomShowDialog.showErrorDialog(
                  context,
                  "Login Failed",
                  result.msg,
                );
              } else {
                CustomShowDialog.showSuccessDialog(
                    context, "Success", "Login Successful!", gotoDashboard);
              }
            }
          }
        },
        child: Text(
          'Login',
          style: kLoginButtonStyle(),
        ),
      ),
    );
  }
}
