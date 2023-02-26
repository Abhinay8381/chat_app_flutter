import 'package:chat_app_flutter/pages/auth/login_page.dart';
import 'package:chat_app_flutter/pages/home_page.dart';
import 'package:chat_app_flutter/services/auth_service.dart';
import 'package:chat_app_flutter/services/database_service.dart';
import 'package:chat_app_flutter/services/storage_services.dart';
import 'package:chat_app_flutter/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  String userName, email;
  ProfilePage({super.key, required this.email, required this.userName});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String photoUrl = "";
  bool isProfileAvailable = false;
  AuthServuce authServuce = AuthServuce();
  @override
  void initState() {
    getPhotoUrl();
    super.initState();
  }

  getPhotoUrl() async {
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserProfileUrl()
        .then((value) {
      setState(() {
        photoUrl = value;
        if (photoUrl == "") {
          isProfileAvailable = false;
        } else {
          isProfileAvailable = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: Drawer(
        child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 50),
            children: <Widget>[
              Icon(
                Icons.account_circle,
                size: 150,
                color: Colors.grey[700],
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                widget.email,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              const Divider(
                height: 2,
              ),
              ListTile(
                onTap: () {
                  nextSecreenReplacement(context, const HomePage());
                },
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                title: const Text(
                  "Groups",
                  style: TextStyle(fontSize: 20),
                ),
                leading: const Icon(
                  Icons.group,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                },
                selected: true,
                selectedColor: Theme.of(context).primaryColor,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                title: const Text(
                  "Profile",
                  style: TextStyle(fontSize: 20),
                ),
                leading: const Icon(
                  Icons.account_circle,
                ),
              ),
              ListTile(
                onTap: () async {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Logout'),
                          content:
                              const Text("Are you sure you want to logout?"),
                          actions: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                authServuce.signOut().whenComplete(() {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LogInPage()),
                                      (route) => false);
                                });
                              },
                              icon: const Icon(
                                Icons.done,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        );
                      });
                },
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                title: const Text(
                  "Logout",
                  style: TextStyle(fontSize: 20),
                ),
                leading: const Icon(
                  Icons.exit_to_app,
                ),
              ),
            ]),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 170, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
                alignment: Alignment.bottomCenter,
                children: isProfileAvailable
                    ? [
                        CircleAvatar(
                          radius: 100,
                          backgroundImage: NetworkImage(photoUrl),
                        ),
                        IconButton(
                          onPressed: () async {
                            await StorageServices().uploadProfilePhoto();
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white70,
                          ),
                          tooltip: 'Upload Profile Image',
                        ),
                      ]
                    : [
                        const CircleAvatar(
                            radius: 100,
                            backgroundImage: AssetImage("assets/user.png")),
                        IconButton(
                          onPressed: () async {
                            await StorageServices().uploadProfilePhoto();
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white70,
                          ),
                          tooltip: 'Upload Profile Image',
                        ),
                      ]),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Full Name:",
                  style: TextStyle(fontSize: 17),
                ),
                Text(
                  widget.userName,
                  style: const TextStyle(fontSize: 17),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Email:",
                  style: TextStyle(fontSize: 17),
                ),
                Text(
                  widget.email,
                  style: const TextStyle(fontSize: 17),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
