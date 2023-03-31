import 'package:flutter/material.dart';
import 'package:sustainable_city_management/app/dashboard/models/user.dart';
import 'package:sustainable_city_management/app/dashboard/views/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final User _user = User();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  void _validatePasswords() {
    if (_formKey.currentState != null) {
      _formKey.currentState!.validate();
    }
  }

  void _submitForm() async {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
      }

      // Send a POST request to the API with the user data
      final response = await http.post(
        Uri.parse('https://scm-backend.rxshri99.live/gateway/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(_user.toJson()),
      );

      if (context.mounted) {
        if (response.statusCode == 200) {
          // Show a dialog to inform the user that the registration was successful
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Registration successful'),
                content: const Text('You have successfully registered.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      // Navigate back to the login page
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => const LoginPage()));
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
          // Clear the form inputs
          _formKey.currentState!.reset();
        } else {
          final error = jsonDecode(response.body)['msg'];
          _showErrorDialog(error);
        }
      }
    }
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: [
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  late List<dynamic> _rolesData;
  String? _selectedRole;

  @override
  void initState() {
    super.initState();
    _rolesData = [];
    _fetchRolesData();
    _passwordController.addListener(_validatePasswords);
    _repeatPasswordController.addListener(_validatePasswords);
  }

  Future<void> _fetchRolesData() async {
    final response = await http
        .get(Uri.parse('https://scm-backend.rxshri99.live/gateway/roles'));
    if (response.body.isNotEmpty) {
      final responseData = json.decode(response.body);
      if (responseData['error'] == false) {
        setState(() {
          _rolesData = responseData['roles_data'];
          _selectedRole =
              _rolesData[0]['role_name']; // Set the initial selected value
        });
      } else {
        _setDefaultRolesData();
      }
    } else {
      setState(() {
        _setDefaultRolesData();
      });
    }
  }

  void _setDefaultRolesData() {
    setState(() {
      _rolesData = [
        {"role_name": "City Manager"},
        {"role_name": "Bus Company"},
        {"role_name": "Bike Company"},
        {"role_name": "Bin Truck Company"}
      ];
      _selectedRole =
          _rolesData[0]['role_name']; // Set the initial selected value
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: const Text('Sign up'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          physics: const BouncingScrollPhysics(),
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 12),
            ),
            // First Name
            TextFormField(
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'First Name',
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                fillColor: Colors.amber,
                filled: true,
              ),
              onSaved: (value) => _user.firstName = value,
            ),
            const SizedBox(height: 16),
            // Last Name
            TextFormField(
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Last Name',
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.amber),
                  borderRadius: BorderRadius.circular(8),
                ),
                fillColor: Colors.amber,
                filled: true,
              ),
              onSaved: (value) => _user.lastName = value,
            ),
            const SizedBox(height: 16),
            // Email
            TextFormField(
              autofocus: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'youremail@email.com',
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                fillColor: Colors.amber,
                filled: true,
              ),
              onSaved: (value) => _user.username = value,
            ),
            const SizedBox(height: 16),
            // Password
            TextFormField(
              autofocus: false,
              obscureText: true,
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: 'Password',
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                fillColor: Colors.amber,
                filled: true,
              ),
              onSaved: (value) => _user.password = value,
            ),
            const SizedBox(height: 16),
            // Repeat Password
            TextFormField(
              autofocus: false,
              obscureText: true,
              controller: _repeatPasswordController,
              decoration: InputDecoration(
                hintText: 'Repeat Password',
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                fillColor: Colors.amber,
                filled: true,
              ),
              validator: (value) {
                if (_passwordController.text !=
                    _repeatPasswordController.text) {
                  return 'Password do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Role',
                border: OutlineInputBorder(),
              ),
              value: _selectedRole,
              onChanged: (newValue) {
                setState(() {
                  _selectedRole = newValue;
                });
              },
              items:
                  _rolesData.map<DropdownMenuItem<String>>((dynamic roleData) {
                return DropdownMenuItem<String>(
                  value: roleData['role_name'],
                  child: Text(roleData['role_name']),
                );
              }).toList(),
              onSaved: (value) => _user.username = _selectedRole,
            ),
            const SizedBox(height: 24),
            // Sign Up Button
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
                backgroundColor: Colors.amber,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              child: TextButton(
                onPressed: _submitForm,
                child: const Text('Sign up'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
