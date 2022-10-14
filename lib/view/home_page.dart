import 'package:chatapp/helper/helper_function.dart';
import 'package:chatapp/services/auth_services.dart';
import 'package:chatapp/services/database_srvices.dart';
import 'package:chatapp/shared/group_tile.dart';
import 'package:chatapp/shared/widget.dart';
import 'package:chatapp/view/login_page.dart';
import 'package:chatapp/view/profile_page.dart';
import 'package:chatapp/view/search_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../shared/constant.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "";
  String email = "";
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";
  AuthServices authServices = AuthServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                  itemCount: snapshot.data["groups"].length,
                  itemBuilder: (context, index) {
                    int reverse = snapshot.data["groups"].length - index - 1;
                    return GroupTile(
                        userName: snapshot.data["fullName"],
                        groupId: getId(snapshot.data["groups"][reverse]),
                        groupName: getName(snapshot.data["groups"][reverse]));
                  });
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor),
          );
        }
      },
    );
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 70),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (() {
                popUpDialog(context);
              }),
              child: const Icon(
                Icons.add_circle,
                color: Colors.grey,
                size: 75,
              ),
            ),
            const Text(
              "You've not joined any groups, tap on the add icon to create a group or also search from top search button.",
              textAlign: TextAlign.center,
            )
          ]),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Create a group",
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _isLoading == true
                    ? Center(
                        child: CircularProgressIndicator(
                            color: Constant.primaryColor),
                      )
                    : TextField(
                        onChanged: (value) {
                          setState(() {
                            groupName = value;
                          });
                        },
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(20)),
                            errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(20)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(20))),
                      ),
              ],
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Constant.primaryColor),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Constant.primaryColor),
                onPressed: () async {
                  if (groupName != "") {
                    setState(() {
                      _isLoading = true;
                    });
                    DatabaseServices(
                            uid: FirebaseAuth.instance.currentUser!.uid)
                        .createGroup(userName,
                            FirebaseAuth.instance.currentUser!.uid, groupName)
                        .whenComplete(() {
                      _isLoading = false;
                    });
                    Navigator.of(context).pop();
                    showSnackbar(
                        context, Colors.green, "Group created successfully.");
                  }
                },
                child: const Text("Create"),
              )
            ],
          );
        });
  }

  gettingUserData() async {
    await HelperFunction.getUserEmailFromSf().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunction.getUserNameFromSf().then((value) {
      setState(() {
        userName = value!;
      });
    });
    await DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(context, const SearchBar());
              },
              icon: const Icon(Icons.search))
        ],
        centerTitle: true,
        backgroundColor: Constant.primaryColor,
        title: const Text(
          "Groups",
          style: TextStyle(
              fontSize: 27, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      drawer: Drawer(
          child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 50),
        children: [
          const Icon(
            Icons.account_circle,
            size: 150,
            color: Colors.blueGrey,
          ),
          SizedBox(
            height: 15,
            child: Text(
              userName.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Constant.primaryColor),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const Divider(
            height: 2,
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
            },
            selected: true,
            selectedColor: Constant.primaryColor,
            leading: const Icon(Icons.group),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            title: const Text(
              "Groups",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          ListTile(
            onTap: () {
              nextScreenReplace(
                  context,
                  ProfilePage(
                    email: email,
                    userName: userName,
                  ));
            },
            leading: const Icon(Icons.group),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            title: const Text(
              "Profile",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          ListTile(
            onTap: () async {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
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
                            authServices.singOut().whenComplete(() {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                  (route) => false);
                            });
                          },
                          icon: const Icon(
                            Icons.done,
                            color: Colors.green,
                          ),
                        )
                      ],
                      title: const Text("Logout"),
                      content: const Text("Are You Sure You Want To Logout"),
                    );
                  });
            },
            leading: const Icon(Icons.exit_to_app),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            title: const Text(
              "Logout",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          )
        ],
      )),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        elevation: 5,
        backgroundColor: Constant.primaryColor,
        child: const Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }
}
