import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'signin.dart';
import 'user.dart';

class Signup extends StatefulWidget {
  Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nidController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'user'; // Default role selection

  Future<void> save() async {
    final user = User(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      dob: _dobController.text,
      phone: _phoneController.text,
      nid: _nidController.text,
      email: _emailController.text,
      password: _passwordController.text,
      role: _selectedRole, // Pass the selected role
    );

    try {
      final response = await http.post(
        Uri.parse("http://localhost:8080/signup"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 201) {
        print('Signup successful: ${response.body}');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Signin()),
        );
      } else {
        print('Failed to sign up: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'images/immigration.png',
                width: 100,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 30),
                    Text(
                      "Register",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          color: Colors.blue),
                    ),
                    Text(
                      "Create an account to continue! ",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                          color: Colors.blue),
                    ),
                    SizedBox(height: 10),
                    _buildTextField(
                      controller: _firstNameController,
                      hintText: 'Enter First Name',
                      icon: Icons.person,
                    ),
                    _buildTextField(
                      controller: _lastNameController,
                      hintText: 'Enter Last Name',
                      icon: Icons.person,
                    ),
                    _buildTextField(
                      controller: _dobController,
                      hintText: 'Enter Date of Birth',
                      icon: Icons.calendar_today,
                    ),
                    _buildTextField(
                      controller: _phoneController,
                      hintText: 'Enter Phone Number',
                      icon: Icons.phone,
                    ),
                    _buildTextField(
                      controller: _nidController,
                      hintText: 'Enter NID',
                      icon: Icons.credit_card,
                    ),
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
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: DropdownButtonFormField<String>(
                        value: _selectedRole,
                        items: ['user', 'police', 'admin'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          icon: Icon(Icons.account_circle, color: Colors.blue),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedRole = newValue!;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a role';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(55, 16, 16, 0),
                      child: Container(
                        height: 40,
                        width: 300,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              save();
                            } else {
                              print("Form validation failed");
                            }
                          },
                          child: Text(
                            "Signup",
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
                            "Already have an Account? ",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Signin()),
                              );
                            },
                            child: Text(
                              "Signin",
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
