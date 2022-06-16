import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_registration_app/Screens/homepage.dart';
import 'package:firebase_registration_app/Widgets/common_widgets.dart';
import 'package:firebase_registration_app/constants/string_constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

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

  double screenHeight = 0;
  double screenWidth = 0;
  Color primary = const Color(0xffeef444c);
  String profilePicLink = "";

  void pickUploadProfilePic() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 75,
    );

    Reference ref =
        FirebaseStorage.instance.ref().child("$_nameController+profilepic.jpg");
    await ref.putFile(File(image!.path));

    ref.getDownloadURL().then((value) async {
      setState(() {
        profilePicLink = value;
        print(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: Colors.lightBlue,
            appBar: AppBar(
              title: Text(GlobalConstants().register),
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            pickUploadProfilePic();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 80, bottom: 24),
                            height: 120,
                            width: 120,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: primary,
                            ),
                            child: Center(
                              child: profilePicLink == ""
                                  ? const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 80,
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(profilePicLink),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(GlobalConstants().uploadImage),
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
                                  "photo": profilePicLink,
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
