import 'package:chat_app_flutter/pages/group_info.dart';
import 'package:chat_app_flutter/services/database_service.dart';
import 'package:chat_app_flutter/widgets/message_tile.dart';
import 'package:chat_app_flutter/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  String groupId, groupName, userName;
  ChatPage(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.userName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();
  String admin = "";
  Stream<QuerySnapshot>? chats;

  @override
  void initState() {
    getChatAndAdmin();
    super.initState();
  }

  getChatAndAdmin() {
    DatabaseService().getChats(widget.groupId).then((value) {
      setState(() {
        chats = value;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((value) {
      setState(() {
        admin = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(widget.groupName),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                nextSecreen(
                    context,
                    GroupInfo(
                        groupId: widget.groupId,
                        admin: admin,
                        groupName: widget.groupName));
              },
              icon: const Icon(Icons.info)),
        ],
      ),
      body: Stack(
        children: <Widget>[
          chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              color: Colors.grey[700],
              child: Row(children: [
                Expanded(
                    child: TextFormField(
                  controller: messageController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Send a message.........",
                      hintStyle: TextStyle(color: Colors.white, fontSize: 16)),
                )),
                const SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: () {
                    sendMessages();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.send,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          )
        ],
      ),
    );
  }

  chatMessages() {
    return Positioned(
      top: 0,
      bottom: MediaQuery.of(context).size.height / 9,
      left: 0,
      right: 0,
      child: StreamBuilder(
        stream: chats,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return MessageTile(
                        message: snapshot.data.docs[index]['message'],
                        sender: snapshot.data.docs[index]['messageSender'],
                        isSentByMe: widget.userName ==
                            snapshot.data.docs[index]['messageSender']);
                  })
              : Container();
        },
      ),
    );
  }

  sendMessages() async {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageModel = {
        "message": messageController.text,
        "messageSender": widget.userName,
        "messageTime": DateTime.now().microsecondsSinceEpoch
      };
      await DatabaseService().sendMessage(widget.groupId, chatMessageModel);
      setState(() {
        messageController.clear();
      });
    }
  }
}
