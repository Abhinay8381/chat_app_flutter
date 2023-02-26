import 'package:chat_app_flutter/pages/chat_page.dart';
import 'package:chat_app_flutter/widgets/widgets.dart';
import 'package:flutter/material.dart';

class GroupTile extends StatefulWidget {
  String groupId, groupName, userName;
  GroupTile(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.userName});

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: GestureDetector(
        onTap: () {
          nextSecreen(
              context,
              ChatPage(
                  groupId: widget.groupId,
                  groupName: widget.groupName,
                  userName: widget.userName));
        },
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(widget.groupName.substring(0, 1).toUpperCase()),
          ),
          title: Text(
            widget.groupName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          subtitle: Text(
            "Join this conversation as ${widget.userName}",
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }
}
