import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_wall_app/src/components/drawer.dart';
import 'package:the_wall_app/src/components/postMsg.dart';
import 'package:the_wall_app/src/components/textfiled.dart';
import 'package:the_wall_app/src/helper/formatdata_helper.dart';
import 'package:the_wall_app/src/resources/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final _inputMsgController = TextEditingController();

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  void goToProfilePage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(child: Text(message)),
      ),
    );
  }

  void sendMsg() {
    if (_inputMsgController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("User Post").add({
        "UserEmail": currentUser.email,
        "Message": _inputMsgController.text,
        "Time": Timestamp.now(),
        "Likes": []
      });
    }

    setState(() {
      _inputMsgController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "The Wall",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey[900],
      ),
      drawer: MyDrawer(
        onLogoutTap: signOut,
        onProfileTap: goToProfilePage,
      ),
      body: SafeArea(
        child: Center(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("User Post")
                      .orderBy("Time")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final post = snapshot.data!.docs[index];
                          return MyPostMsg(
                            message: post['Message'],
                            user: post['UserEmail'],
                            postID: post.id,
                            likes: List<String>.from(post['Likes'] ?? []),
                            time: formatDayMonthYear(post['Time']),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      displayMessage(snapshot.error.toString());
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: MyTextFiled(
                        controller: _inputMsgController,
                        hintText: "Input message",
                        obscureText: false,
                      ),
                    ),
                    IconButton(
                      onPressed: sendMsg,
                      icon: const Icon(
                        Icons.arrow_circle_up,
                        size: 30,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  "Loggin as: ${currentUser.email}",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
