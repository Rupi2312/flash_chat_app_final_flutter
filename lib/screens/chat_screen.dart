import 'package:flash_chat_app_final_flutter/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



late User loggedInUser;
final _firestore = FirebaseFirestore.instance;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static const String id = 'chat_screen';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  late String messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      _auth.authStateChanges().listen((User? user) {
        if (user != null) {
          loggedInUser = user;
          print(loggedInUser.email);
        }
      });
    } catch(e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: [
          IconButton(
              onPressed: () async {
                await _auth.signOut();
                if (mounted) {
                  Navigator.popUntil(context, ModalRoute.withName(WelcomeScreen.id));
                }
              },
              icon: const Icon(Icons.close))
        ],
        title: const Text('Flash Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
          child: Column(
            children: [
              MessagesStream(),
              Container(
                decoration: const BoxDecoration(
                    border: Border(
                        top: BorderSide(
                            color: Colors.lightBlueAccent,
                            width: 2
                        )
                    )
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: messageController,
                          onChanged: (value) {
                            messageText = value;
                          },
                          decoration: const InputDecoration(
                              hintText: 'Type your message here',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0
                              ),
                              border: InputBorder.none
                          ),
                        )
                    ),
                    TextButton(
                        onPressed: () {
                          messageController.clear();
                          _firestore.collection('messages').add({
                            'sender' : loggedInUser.email,
                            'text' : messageText,
                            'createdAt' : FieldValue.serverTimestamp()
                          });
                        },
                        child: const Text('Send')
                    )
                  ],
                ),
              )
            ],
          )
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  const MessagesStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages')
          .orderBy('createdAt', descending: true).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data!.docs;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message['text'];
          final messageSender = message['sender'];

          final currentUser = loggedInUser.email;

          final messageBubble = MessageBubble(
              sender: messageSender,
              text: messageText,
              isMe: currentUser == messageSender
          );

          messageBubbles.add(messageBubble);
        }
        return Expanded(
            child: ListView(
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: messageBubbles,
            )
        );
      },
    );
  }
}


class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key, required this.sender, required this.text, required this.isMe
  });

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: isMe? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: const TextStyle(
                fontSize: 12,
                color: Colors.grey
            ),
          ),
          Material(
            borderRadius: isMe
                ? const BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30))
                : const BorderRadius.only(
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)),
            elevation: 5,
            color: isMe? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                text,
                style: TextStyle(
                    color: isMe? Colors.white : Colors.black,
                    fontSize: 15
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}



//
// final _firestore= FirebaseFirestore.instance;
// late User loggedInUser;
// class ChatScreen extends StatefulWidget {
//
//   static const String id="chat_screen";
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//
//   final messageTextController= TextEditingController();
//   final _auth= FirebaseAuth.instance;
//
//  late String messageText;
//
// @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getCurrentUser();
//   }
//
//        void getCurrentUser() async {
//
//           try{
//             final user= await _auth.currentUser!;
//
//             if(user!=null){
//               loggedInUser=user;
//               print(loggedInUser.email);
//             }
//
//           }
//           catch(e){
//             print(e);
//
//           }
//         }
//
//         // Future<void> getMessages() async {
//         //   CollectionReference _collectionRef = firestore.collection('messages');
//         //
//         //
//         //     // Get docs from collection reference
//         //     QuerySnapshot querySnapshot = await _collectionRef.get();
//         //    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
//         //
//         //   print(allData);
//         //
//         //
//         // }
//         //
//
// void messagesStream() async{
//
//
//
//  await for(var snapshot in _firestore.collection('messages').snapshots()){
//   for(var message in snapshot.docs){
//     print(message.data);
//   }
//  }
// }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: null,
//         actions: <Widget>[
//           IconButton(
//               icon: Icon(Icons.close),
//               onPressed: () {
//
//                 _auth.signOut();
//                 Navigator.pop(context);
//               }),
//         ],
//         title: Text('⚡️Chat'),
//         backgroundColor: Colors.lightBlueAccent,
//       ),
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//
//
//
//             StreamBuilder<QuerySnapshot>(
//                 stream: _firestore.collection('messages').snapshots(),
//                 builder: (context,snapshot) {
//
//                   if (snapshot.hasError) {
//                     return Text('Something went wrong');
//                   }
//
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(
//                       child: CircularProgressIndicator(
//                         backgroundColor: Colors.lightBlueAccent,
//                       ),
//                     );
//                   }
//
//
//                   final currentUser= loggedInUser.email;
//                   return   Expanded(
//
//                        child: ListView(
//                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
//                          reverse: true,
//                           children: snapshot.data!.docs.map((DocumentSnapshot document) {
//                           Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
//
//                          return   Column(
//                            children:[ listTile(currentUser: currentUser, data: data),]
//                          );
//                         }).toList(),
//                     ),
//                      );
//
//
//                     // if(messages !=null) {
//                     //   for (var message in messages) {
//                     //     final messageText = message.data.data()['text'];
//                     //     final messageSender = message.data.data()['sender'];
//                     //
//                     //     final messageWidget = Text(
//                     //         '$messageText from $messageSender');
//                     //
//                     //     messageWidgets.add(messageWidget);
//                     //   }
//                     //   return Column(
//                     //     children: messageWidgets,
//                     //   );
//                     // }
//
//                   }
//
//                 ),
//             Container(
//               decoration: kMessageContainerDecoration,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   Expanded(
//                     child: TextField(
//                       controller: messageTextController,
//                       onChanged: (value) {
//                       messageText=value;
//                       },
//                       decoration: kMessageTextFieldDecoration,
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       //messageText + loggedInUser
//                       messageTextController.clear();
//                       _firestore.collection('messages').add({
//                         'text': messageText,
//                         'sender':loggedInUser.email  ,
//                       });
//
//
//                     },
//                     child: Text(
//                       'Send',
//                       style: kSendButtonTextStyle,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class listTile extends StatelessWidget {
//   const listTile({
//     super.key,
//     required this.currentUser,
//     required this.data,
//   });
//
//   final String? currentUser;
//   final Map<String, dynamic> data;
//
//
//   @override
//   Widget build(BuildContext context) {
//     bool isMe= (currentUser== data['sender']) ;
//     return Padding(
//       padding: EdgeInsets.all(10.0),
//       child: Column(
//         crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: [
//           Text(
//             data['sender'],
//             style: TextStyle(
//               fontSize: 12.0,
//               color: Colors.black54,
//             ),
//           ),
//           Material(
//             borderRadius: isMe ? BorderRadius.only(topLeft: Radius.circular(30.0,), bottomLeft: Radius.circular(30.0), bottomRight: Radius.circular(30.0)) : BorderRadius.only(bottomLeft: Radius.circular(30.0),
//             bottomRight: Radius.circular(30.0),
//             topRight: Radius.circular(30.0)),
//              elevation: 5.0,
//             color:(isMe) ? Colors.lightBlueAccent : Colors.white,
//
//             child: Padding(
//               padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//               child: Text(
//                 data['text'],
//                 style: TextStyle(
//                   fontSize:15.0,
//                 ),
//
//         ),
//             ),
//
//         ),
//         ]
//       ),
//     );
//   }
// }
