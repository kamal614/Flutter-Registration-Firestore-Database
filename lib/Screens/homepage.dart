import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_registration_app/constants/string_constants.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var snapshot =
      FirebaseFirestore.instance.collection("regUserInfo").snapshots();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.lightBlue,
          appBar: AppBar(
            title: Text(GlobalConstants().homepage),
          ),
          body: SafeArea(
            child: StreamBuilder<QuerySnapshot>(
                stream: snapshot,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      return Card(
                        color: Colors.blue,
                        elevation: 6,
                        margin: const EdgeInsets.all(10),
                        child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: CircleAvatar(
                                    backgroundColor: Colors.purple,
                                    child: Image.network(snapshot
                                        .data!.docs[index]['photo']
                                        .toString())),
                                title: Text(
                                    "Name : ${snapshot.data!.docs[index]['name'].toString()}"),
                                trailing: Text(
                                    "Email : ${snapshot.data!.docs[index]['email'].toString()}"),
                                subtitle: Text(
                                    "Mobile no.  ${snapshot.data!.docs[index]['phone'].toString()}"),
                                isThreeLine: true,
                              );
                            }),
                      );
                    }
                    return const Center(child: Text("No Data!!"));
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          )

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
          ),
    );
  }
}
