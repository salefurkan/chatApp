import 'package:flutter/material.dart';

import 'package:private_chat_app/helper/constans.dart';
import 'package:private_chat_app/services/database.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  // final String chattingUser;
  ConversationScreen({
    this.chatRoomId,
    // this.chattingUser,
  });

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageCtrl = TextEditingController();

  Stream chatMessagesStream;

  Widget chatMessageList() {
    return StreamBuilder(
        stream: chatMessagesStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return MessageTile(
                        message: snapshot.data.docs[index].data()['message'],
                        isSendByMe:
                            snapshot.data.docs[index].data()["sendBy"] ==
                                Constants.myName);
                  },
                )
              : Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                );
        });
  }

  sendMessage() {
    if (messageCtrl.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageCtrl.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageCtrl.text = "";
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((val) {
      setState(() {
        chatMessagesStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        actions: [
          FloatingActionButton(
            onPressed: () {},
            mini: true,
            child: Icon(Icons.person),
          )
        ],
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            chatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Color(0x54FFFFFF),
                padding: EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageCtrl,
                        decoration: InputDecoration(
                          hintText: 'Mesaj yaz',
                          hintStyle: TextStyle(color: Colors.black87),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            const Color(0x36FFFFF),
                            const Color(0x0FFFFFF)
                          ]),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.send,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  const MessageTile({
    Key key,
    this.message,
    this.isSendByMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: isSendByMe ? 0 : 24, right: isSendByMe ? 24 : 0),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSendByMe
                ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                : [const Color(0xFAAAAAAA), const Color(0xFAAAAAAA)],
          ),
          borderRadius: isSendByMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                )
              : BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
        ),
        child: Text(message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
            )),
      ),
    );
  }
}
