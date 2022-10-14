import 'package:chatapp/services/database_srvices.dart';
import 'package:chatapp/shared/constant.dart';
import 'package:chatapp/shared/messageLook.dart';
import 'package:chatapp/shared/widget.dart';
import 'package:chatapp/view/group_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;

  const ChatPage(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;

  TextEditingController messageController = TextEditingController();
  String admin = "";

  @override
  void initState() {
    // TODO: implement initState
    getChatandAdmin();
    super.initState();
  }

  getChatandAdmin() {
    DatabaseServices().getChats(widget.groupId).then((value) {
      setState(() {
        chats = value;
      });
    });
    DatabaseServices().getGroupAdmin(widget.groupId).then((value) {
      setState(() {
        admin = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName.toUpperCase()),
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(
                    context,
                    GroupInfo(
                        groupId: widget.groupId,
                        groupName: widget.groupName,
                        adminName: admin));
              },
              icon: const Icon(Icons.info))
        ],
        centerTitle: true,
        elevation: 0,
        backgroundColor: Constant.primaryColor,
      ),
      body: Stack(
        children: <Widget>[
          SizedBox(
            height: 700,
            width: MediaQuery.of(context).size.width,
          ),
          chatMessages(),
          Positioned(
              bottom: 0,
              child: SizedBox(
                // alignment: Alignment.topCenter,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey[700],
                  child: Row(children: [
                    Expanded(
                        child: TextFormField(
                      controller: messageController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "Send a message...",
                        hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                        border: InputBorder.none,
                      ),
                    )),
                    const SizedBox(
                      width: 12,
                    ),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Constant.primaryColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Center(
                            child: Icon(
                          Icons.send,
                          color: Colors.white,
                        )),
                      ),
                    )
                  ]),
                ),
              ))
        ],
      ),
    );
  }

  chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? SizedBox(
                height: 530,
                child: ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return MessageLook(
                        message: snapshot.data.docs[index]['message'],
                        sender: snapshot.data.docs[index]['sender'],
                        sentByMe: widget.userName ==
                            snapshot.data.docs[index]['sender']);
                  },
                ),
              )
            : Container();
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseServices().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }
}
