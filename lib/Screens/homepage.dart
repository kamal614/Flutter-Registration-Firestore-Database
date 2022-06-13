import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_registration_app/Screens/register_page.dart';
import 'package:firebase_registration_app/Widgets/common_widgets.dart';
import 'package:firebase_registration_app/constants/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var fireStoreData =
      FirebaseFirestore.instance.collection("regUserInfo").snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lightBlue,
        appBar: AppBar(
          title: Text(GlobalConstants().homepage),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: fireStoreData,
            builder: (context, snapshot) {
              if (!snapshot.hasData) 
               {
                 return const Center(child: CircularProgressIndicator());
               }
                return ListView.builder(itemCount: snapshot.data!.docs.length ,itemBuilder: (context, int index {
                  
                }));
              
            })

        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Center(
        //       child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       commonButton(context, GlobalConstants().logout, () {
        //         Get.offAll(const RegisterApp());
        //       })
        //     ],
        //   )),
        // ),
        );
  }
}
