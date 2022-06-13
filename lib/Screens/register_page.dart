import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_registration_app/Screens/homepage.dart';
import 'package:firebase_registration_app/Widgets/common_widgets.dart';
import 'package:firebase_registration_app/constants/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterApp extends StatefulWidget {
  const RegisterApp({Key? key}) : super(key: key);

  @override
  State<RegisterApp> createState() => _RegisterAppState();
}

class _RegisterAppState extends State<RegisterApp> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: Colors.lightBlue,
            appBar: AppBar(
              title: Text(GlobalConstants().register),
            ),
            body: SafeArea(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.white,
                          minRadius: 30,
                          child: Text(
                            "R",
                            style: TextStyle(color: Colors.red, fontSize: 20),
                          ),
                        ),
                        const SizedBox(height: 15),
                        commonTextField(
                            GlobalConstants().name,
                            Icons.verified_user,
                            false,
                            _nameController, (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Name';
                          } else if (value.length < 2) {
                            return 'Length of name should be minimum 3';
                          }
                          return null;
                        }),
                        const SizedBox(height: 10),
                        commonTextField(GlobalConstants().mobile, Icons.phone,
                            false, _mobileController, (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter correct mobile no.';
                          } else if (value.length < 9) {
                            return 'Phone no. should be 10 digits';
                          }
                          return null;
                        }),
                        const SizedBox(height: 10),
                        commonTextField(GlobalConstants().email, Icons.email,
                            false, _emailController, (value) {
                          validateEmail(value.toString());
                        }),
                        const SizedBox(height: 10),
                        commonTextField(
                          GlobalConstants().password,
                          Icons.password,
                          true,
                          _passwordController,
                          (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter correct password';
                            } else if (value.length < 5) {
                              return 'Password should be at least 6 characters.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        commonButton(context, GlobalConstants().register, () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: _emailController.text,
                                      password: _passwordController.text)
                                  .then((value) {
                                FirebaseFirestore.instance
                                    .collection('regUserInfo')
                                    .doc(value.user!.uid)
                                    .set({
                                  "email": value.user!.email,
                                  "name": _nameController.text,
                                  "phone": _mobileController.text,
                                  "photo": value.user!.photoURL,
                                }
                                        // {"email": value.user!.email},
                                        ).then((value) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Get.offAll(const Homepage());
                                });
                              });
                            } catch (e) {
                              ScaffoldMessenger(child: Text(e.toString()));
                            }
                          }
                        })
                      ]),
                ),
              ),
            ));
  }
}

String? validateEmail(String value) {
  Pattern pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
      r"{0,253}[a-zA-Z0-9])?)*$";
  RegExp regex = new RegExp(pattern.toString());
  if (!regex.hasMatch(value) || value == null) {
    return 'Enter a valid email address';
  } else {
    return null;
  }
}
