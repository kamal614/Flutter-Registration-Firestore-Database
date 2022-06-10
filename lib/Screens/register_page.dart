import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    commonTextField(GlobalConstants().name, Icons.verified_user,
                        false, _nameController),
                    const SizedBox(height: 10),
                    commonTextField(GlobalConstants().mobile, Icons.phone,
                        false, _mobileController),
                    const SizedBox(height: 10),
                    commonTextField(GlobalConstants().email, Icons.email, false,
                        _emailController),
                    const SizedBox(height: 10),
                    commonTextField(GlobalConstants().password, Icons.password,
                        true, _passwordController),
                    const SizedBox(height: 10),
                    commonButton(context, GlobalConstants().register, () {
                      print(_nameController.text);
                      print(_mobileController.text);
                      isLoading = true;
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
                            isLoading = false;
                            Get.offAll(const Homepage());
                          });
                        });
                      } catch (e) {
                        ScaffoldMessenger(child: Text(e.toString()));
                      }
                    })
                  ]),
            ));
  }
}
