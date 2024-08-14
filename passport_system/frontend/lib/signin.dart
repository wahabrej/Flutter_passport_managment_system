import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'userdashboard.dart';
import 'admindashboard.dart';
import 'polichdashboard.dart';
import 'signup.dart';

class Signin extends StatefulWidget {
  Signin({Key? key}) : super(key: key);

  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _signIn() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final response = await http.post(
          Uri.parse("http://localhost:8080/signin"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'email': _emailController.text,
            'password': _passwordController.text,
          }),
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);

          // Debugging: Print the entire response
          print('Response data: $responseData');

          // Extract user data from the response
          if (responseData is Map<String, dynamic> &&
              responseData.containsKey('user')) {
            final user = responseData['user'];
            if (user is Map<String, dynamic> &&
                user.containsKey('id') &&
                user.containsKey('role')) {
              final userId = user['id'];
              final role = user['role'];
              print('User role: $role');

              if (userId is String) {
                print('Signin successful: $userId');
                await _storeUserId(
                    userId); // Store user ID in SharedPreferences

                // Navigate based on the role
                if (role == 'admin') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Admindashboard()),
                  );
                } else if (role == 'police') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Polichdashboard()),
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Userdashboard(userId: userId)),
                  );
                }
              } else {
                print('Error: userId is not a String');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Invalid user ID format')),
                );
              }
            } else {
              print('Error: user object missing id or role');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('User object missing id or role')),
              );
            }
          } else {
            print('Error: user not found in response');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('User not found in response')),
            );
          }
        } else {
          print('Failed to sign in: ${response.body}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to sign in')),
          );
        }
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred')),
        );
      }
    } else {
      print("Form validation failed");
    }
  }

  Future<void> _storeUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId); // Store user ID
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Image(
                image: AssetImage('images/immigration.png'),
                height: 100,
                width: 100,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 150),
                  Text(
                    "Sign in to your Account",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.blue),
                  ),
                  SizedBox(height: 25),
                  _buildTextField(
                    controller: _emailController,
                    hintText: 'Enter Email',
                    icon: Icons.email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter something';
                      } else if (RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return null;
                      } else {
                        return 'Enter valid email';
                      }
                    },
                  ),
                  _buildTextField(
                    controller: _passwordController,
                    hintText: 'Enter Password',
                    icon: Icons.vpn_key,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter something';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(55, 16, 16, 0),
                    child: Container(
                      height: 50,
                      width: 400,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        onPressed: _signIn,
                        child: Text(
                          "Signin",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(95, 20, 0, 0),
                    child: Row(
                      children: [
                        Text(
                          "Don't have an Account? ",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Signup()),
                            );
                          },
                          child: Text(
                            "Signup",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.blue),
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.blue),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.blue),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
