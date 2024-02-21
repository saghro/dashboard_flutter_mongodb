import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/screen/signIn_screen.dart';
import 'dart:convert';
import 'package:frontend/model/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class SignUpLayoutDesktop extends StatefulWidget {
  const SignUpLayoutDesktop({Key? key}) : super(key: key);

  @override
  State<SignUpLayoutDesktop> createState() => _SignUpLayoutDesktopState();
}

class _SignUpLayoutDesktopState extends State<SignUpLayoutDesktop> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController confirmPasswordController;
  late User user;

  @override
  void initState() {
    super.initState();
    confirmPasswordController = TextEditingController();
    user = User("", "", "");
  }

  @override
  void dispose() {
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> save() async {
    try {
      var res = await http.post(
        Uri.parse("http://localhost:8080/signup"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': user.email,
          'password': user.password,
          'fullName': user.fullName,
        }),
      );
      if (res.statusCode == 200) {
        print("User registered successfully");
      } else {
        print("Failed to register user");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      body: Center(
        child: Stack(
          children: [

            Container(
              height: screenHeight / 1.0,
              width: screenWidth/2,
              alignment: Alignment.center,
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Text(
                        "SignUp",
                        style: GoogleFonts.greatVibes(
                          fontWeight: FontWeight.bold,
                          fontSize: isSmallScreen ? 30 : 50,
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(

                          onChanged: (value) {
                            setState(() {
                              user.email = value;
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter Something';
                            } else if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$")
                                .hasMatch(value)) {
                              return 'Enter valid email';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Enter Email",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                              const BorderSide(color: Colors.lightBlueAccent),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                              const BorderSide(color: Colors.lightBlueAccent),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                              user.fullName = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: "Enter Full Name",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                              const BorderSide(color: Colors.lightBlueAccent),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                              const BorderSide(color: Colors.lightBlueAccent),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                              user.password = value;
                            });
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Enter Password",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                              const BorderSide(color: Colors.lightBlueAccent),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                              const BorderSide(color: Colors.lightBlueAccent),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: confirmPasswordController,
                          obscureText: true,
                          validator: (value) {
                            if (value != user.password) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Confirm Password",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                              const BorderSide(color: Colors.lightBlueAccent),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                              const BorderSide(color: Colors.lightBlueAccent),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          height: 50,
                          width: isSmallScreen ? 200 : 400,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                save();
                              } else {
                                print("Form validation failed");
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                backgroundColor: Colors.lightBlueAccent),
                            child: const Text('SignUp'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(isSmallScreen ? 20 : 65, 20, 0, 0),
                        child: Row(
                          children: [
                            const Text(
                              "Already have Account ?",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()));
                              },
                              child: const Text(
                                "SignIn",
                                style: TextStyle(
                                    color: Colors.lightBlueAccent,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
