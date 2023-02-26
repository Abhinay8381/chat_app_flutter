import 'package:chat_app_flutter/helpers/helper_functions.dart';
import 'package:chat_app_flutter/pages/chat_page.dart';
import 'package:chat_app_flutter/services/database_service.dart';
import 'package:chat_app_flutter/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isLoading = false, hasSearched = false, isjoined = false;
  QuerySnapshot? searchSnapshot;
  TextEditingController searchController = TextEditingController();
  String userName = "";
  User? user;
  @override
  void initState() {
    getCurrentUserNameandId();
    super.initState();
  }

  getCurrentUserNameandId() async {
    await HelperFunctions.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: const Text("Search"),
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Search Groups.....",
                    hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                    border: InputBorder.none,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  initiateSearchMethod();
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(40)),
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ),
            ]),
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor),
                )
              : groupList(),
        ],
      ),
    );
  }

  initiateSearchMethod() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
    }
    await DatabaseService()
        .searchByName(searchController.text)
        .then((snapshot) {
      setState(() {
        searchSnapshot = snapshot;
        isLoading = false;
        hasSearched = true;
      });
    });
  }

  groupList() {
    return hasSearched
        ? ListView.builder(
            itemCount: searchSnapshot!.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return groupTile(
                  searchSnapshot!.docs[index]['groupId'],
                  searchSnapshot!.docs[index]['groupName'],
                  searchSnapshot!.docs[index]['admin'],
                  userName);
            },
          )
        : Container();
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  joinedOrNot(String groupName, String groupId, String userName) async {
    await DatabaseService(uid: user!.uid)
        .isUSerJoined(groupId, groupName, userName)
        .then((value) {
      setState(() {
        isjoined = value;
      });
    });
  }

  Widget groupTile(
      String groupId, String groupName, String admin, String userName) {
    joinedOrNot(groupName, groupId, userName);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        radius: 30,
        child: Text(
          groupName.substring(0, 1).toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        groupName,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text("Admin: ${getName(admin)}"),
      trailing: InkWell(
        onTap: () async {
          await DatabaseService(uid: user!.uid)
              .toggleUserJoin(groupId, groupName, userName);
          if (isjoined == true) {
            setState(() {
              isjoined = !isjoined;
              showSnackBar(context, "Successfully joined group $groupName",
                  Colors.green);
            });
            Future.delayed(const Duration(seconds: 2), () {
              nextSecreen(
                  context,
                  ChatPage(
                      groupId: groupId,
                      groupName: groupName,
                      userName: userName));
            });
          } else {
            setState(() {
              isjoined = !isjoined;
              showSnackBar(context, "Successfully left the group $groupName",
                  Colors.red);
            });
          }
        },
        child: isjoined
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.blueGrey[400],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white, width: 1)),
                child: const Text(
                  "Joined",
                  style: TextStyle(color: Colors.black, fontSize: 17),
                ),
              )
            : Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white, width: 1)),
                child: const Text("Join Now",
                    style: TextStyle(color: Colors.white, fontSize: 17)),
              ),
      ),
    );
  }
}
