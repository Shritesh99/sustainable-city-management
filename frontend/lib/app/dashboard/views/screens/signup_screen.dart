import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sustainable_city_management/app/config/routes/app_pages.dart';
import 'package:sustainable_city_management/app/controller/ui_controller.dart';
import 'package:sustainable_city_management/app/dashboard/models/roles_model.dart';
import 'package:sustainable_city_management/app/dashboard/models/user.dart';
import 'package:sustainable_city_management/app/constants/app_constants.dart';
import 'package:sustainable_city_management/app/services/user_services.dart';
import 'package:sustainable_city_management/app/dashboard/views/components/custom_dialog.dart';
// import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();

  late List<RolesDatum> _rolesData;
  String? _selectedRole;

  final _formKey = GlobalKey<FormState>();
  final User _user = User();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    super.dispose();
  }

  void _fetchRolesData() async {
    await UserServices().getRolesFromApi().then((rolesList) => setState(() {
          _rolesData = rolesList;
          _selectedRole = _rolesData[0].roleName;
          debugPrint("rolesList: $rolesList");
        }));
  }

  @override
  void initState() {
    super.initState();
    _setDefaultRolesData();
    _fetchRolesData();
  }

  int? getRoleIdForRoleName(String? roleName) {
    for (var roleData in _rolesData) {
      if (roleData.roleName == roleName) {
        return roleData.roleId;
      }
    }
    return null;
  }

  void _setDefaultRolesData() {
    setState(() {
      var auths = [
        "AirQuality",
        "NoiseInformation",
        "BusMap",
        "PedestrianHeatmap",
        "BinTrucksMap"
      ];
      _rolesData = [
        RolesDatum(roleId: 0, roleName: "City Manager", auths: auths),
      ];
      _selectedRole = _rolesData[0].roleName; // Set the initial selected value
    });
  }

  UIController uiController = Get.put(UIController());
  UserServices userServices = UserServices();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > LargeScreenWidth) {
                return _buildLargeScreen(size, uiController, theme);
              } else {
                return _buildSmallScreen(size, uiController, theme);
              }
            },
          )),
    );
  }

  /// For large screens
  Widget _buildLargeScreen(
      Size size, UIController uiController, ThemeData theme) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 50, left: 60),
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
          child: _buildMainBody(size, uiController, theme),
        ),
      ],
    );
  }

  /// For Small screens
  Widget _buildSmallScreen(
      Size size, UIController uiController, ThemeData theme) {
    return Center(
      child: _buildMainBody(size, uiController, theme),
    );
  }

  void gotoLogin() {
    Get.toNamed(Routes.login);
  }

  void _submitForm() async {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
      }

      // Send a POST request to the API with the user data
      final response = await userServices.register(_user);

      if (context.mounted) {
        if (!response.error) {
          // Show a dialog to inform the user that the registration was successful
          String title = "Registration successful";
          String message = "You have successfully registered.";
          CustomShowDialog.showSuccessDialog(
              context, title, message, gotoLogin);
          // Clear the form inputs
          _formKey.currentState!.reset();
        } else {
          CustomShowDialog.showErrorDialog(
              context, "Register Failed", response.msg);
        }
      }
    }
  }

  /// Main Body
  Widget _buildMainBody(Size size, UIController uiController, ThemeData theme) {
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
              padding: size.width > LargeScreenWidth
                  ? const EdgeInsets.only(left: 20.0, top: 100)
                  : const EdgeInsets.only(left: 20.0),
              child: Text(
                'Sign Up',
                style: kLoginTitleStyle(size),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                'Create Account',
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
                    /// user first name
                    TextFormField(
                      style: kTextFormFieldStyle(),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        hintText: 'First Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                      onSaved: (value) => _user.firstName = value,

                      controller: firstNameController,
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter First Name';
                        } else if (value.length < 4) {
                          return 'at least enter 4 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),

                    TextFormField(
                      style: kTextFormFieldStyle(),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        hintText: 'Last Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                      onSaved: (value) => _user.lastName = value,

                      controller: lastNameController,
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter First Name';
                        } else if (value.length < 4) {
                          return 'at least enter 4 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),

                    /// Email
                    TextFormField(
                      style: kTextFormFieldStyle(),
                      controller: emailController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email_rounded),
                        hintText: 'youremail@email.com',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                      onSaved: (value) => _user.username = value,
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
                        controller: passwordController,
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
                        onSaved: (value) => _user.password = value,
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the password';
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
                      height: size.height * 0.02,
                    ),

                    /// repeat password
                    Obx(
                      () => TextFormField(
                        style: kTextFormFieldStyle(),
                        controller: repeatPasswordController,
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
                          hintText: 'Repeat Password',
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the password';
                          } else if (passwordController.text !=
                              repeatPasswordController.text) {
                            return 'Password do not match';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),

                    // choose role
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Select Your Role',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedRole,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedRole = newValue;
                        });
                      },
                      items: _rolesData
                          .map<DropdownMenuItem<String>>((RolesDatum roleData) {
                        return DropdownMenuItem<String>(
                          value: roleData.roleName,
                          child: Text(roleData.roleName),
                        );
                      }).toList(),
                      onSaved: (value) =>
                          _user.roleId = getRoleIdForRoleName(value),
                    ),

                    SizedBox(
                      height: size.height * 0.03,
                    ),

                    /// SignUp Button
                    signUpButton(theme),
                    SizedBox(
                      height: size.height * 0.03,
                    ),

                    /// Navigate To Login Screen
                    GestureDetector(
                      onTap: () {
                        gotoLogin();
                        firstNameController.clear();
                        lastNameController.clear();
                        emailController.clear();
                        passwordController.clear();
                        repeatPasswordController.clear();
                        _formKey.currentState?.reset();

                        uiController.isObscure.value = true;
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have an account?',
                          style: kHaveAnAccountStyle(size),
                          children: [
                            TextSpan(
                                text: " Login",
                                style: kLoginOrSignUpTextStyle(size)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.1,
            ),
          ],
        ),
      ),
    );
  }

  // SignUp Button
  Widget signUpButton(ThemeData theme) {
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
        onPressed: () {
          // Validate returns true if the form is valid, or false otherwise.
          if (_formKey.currentState!.validate()) {
            _submitForm();
          }
        },
        child: Text(
          'Sign Up',
          style: kLoginButtonStyle(),
        ),
      ),
    );
  }
}
