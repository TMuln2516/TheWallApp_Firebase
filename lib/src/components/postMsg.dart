import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_wall_app/src/components/like_button.dart';

class MyPostMsg extends StatefulWidget {
  final String message;
  final String user;
  final String postID;
  final List<String> likes;
  const MyPostMsg(
      {super.key,
      required this.message,
      required this.user,
      required this.postID,
      required this.likes});

  @override
  State<MyPostMsg> createState() => _MyPostMsgState();
}

class _MyPostMsgState extends State<MyPostMsg> {
  final _currentUser = FirebaseAuth.instance.currentUser!;
  bool isLike = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLike = widget.likes.contains(_currentUser.email);
  }

  void toggleLike() {
    setState(() {
      isLike = !isLike;
    });

    //Access Doucument in Firebase add Email to Likes
    DocumentReference postRef =
        FirebaseFirestore.instance.collection("User Post").doc(widget.postID);

    if (isLike) {
      //Add Email to Likes
      postRef.update({
        'Likes': FieldValue.arrayUnion([_currentUser.email])
      });
    } else {
      //Remove
      postRef.update({
        'Likes': FieldValue.arrayRemove([_currentUser.email])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(25),
      margin: const EdgeInsets.only(top: 25),
      child: Row(
        children: [
          Container(
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.grey[400]),
            padding: const EdgeInsets.all(10),
            child: const Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user,
                style: TextStyle(color: Colors.grey[500]),
              ),
              const SizedBox(height: 5),
              Text(
                widget.message,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Spacer(
            //Spacer()
            flex: 1,
          ),
          Column(
            children: [
              //Like Button
              MyLikeButton(onTap: toggleLike, isLiked: isLike),
              //count Like
              Text(
                widget.likes.length.toString(),
                style: const TextStyle(color: Colors.black),
              )
            ],
          ),
        ],
      ),
    );
  }
}
