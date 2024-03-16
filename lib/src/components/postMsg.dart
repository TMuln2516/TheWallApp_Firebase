import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_wall_app/src/components/comment.dart';
import 'package:the_wall_app/src/components/comment_button.dart';
import 'package:the_wall_app/src/components/like_button.dart';
import 'package:the_wall_app/src/helper/formatdata_helper.dart';

class MyPostMsg extends StatefulWidget {
  final String message;
  final String user;
  final String postID;
  final List<String> likes;
  final String time;
  const MyPostMsg(
      {super.key,
      required this.message,
      required this.user,
      required this.postID,
      required this.likes,
      required this.time});

  @override
  State<MyPostMsg> createState() => _MyPostMsgState();
}

class _MyPostMsgState extends State<MyPostMsg> {
  final _currentUser = FirebaseAuth.instance.currentUser!;
  bool isLike = false;
  int commentCount = 0;
  final _commentTextController = TextEditingController();

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

  //Add Comment
  void addCommnet(String commentText) {
    //Add in Firabae
    setState(() {
      FirebaseFirestore.instance
          .collection("User Post")
          .doc(widget.postID)
          .collection("Comment")
          .add(({
            "CommentText": commentText,
            "CommentBy": _currentUser.email,
            "CommentTime": Timestamp.now()
          }));
    });
  }

  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Comment"),
        content: TextField(
          controller: _commentTextController,
          decoration: const InputDecoration(hintText: "Write your comment..."),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _commentTextController.clear();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
              onPressed: () {
                addCommnet(_commentTextController.text);
                _commentTextController.clear();
                Navigator.pop(context);
              },
              child: const Text("Post"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(25),
      margin: const EdgeInsets.only(top: 25),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.grey[400]),
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
                    widget.message,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.user,
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  Text(
                    widget.time,
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
              const Spacer(
                //Spacer()
                flex: 1,
              ),
              Column(
                children: [
                  //Comment Button
                  MyCommentButton(onTap: showCommentDialog),
                  //count Comment
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('User Post')
                        .doc(widget.postID)
                        .collection('Comment')
                        .snapshots(),
                    builder: (context, snapshot) {
                      int countDataComment = 0;
                      if (snapshot.hasData) {
                        countDataComment = snapshot.data!.docs.length;
                      }
                      return Text(countDataComment.toString());
                    },
                  )
                ],
              ),
              const SizedBox(
                width: 10,
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
          const SizedBox(
            height: 10,
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("User Post")
                .doc(widget.postID)
                .collection("Comment")
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((doc) {
                  final commentData = doc.data();
                  return Comment(
                    text: commentData["CommentText"],
                    name: commentData["CommentBy"],
                    time: formatDayMonthYear(commentData["CommentTime"]),
                  );
                }).toList(),
              );
            },
          )
        ],
      ),
    );
  }
}
