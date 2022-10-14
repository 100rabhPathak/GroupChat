import 'package:chatapp/shared/constant.dart';
import 'package:chatapp/view/home_page.dart';
import 'package:chatapp/view/login_page.dart';
import 'package:flutter/material.dart';

import '../services/auth_services.dart';
import '../shared/widget.dart';

class ProfilePage extends StatefulWidget {
  String userName;
  String email;

  ProfilePage({Key? key, required this.userName, required this.email})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthServices authServices = AuthServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Constant.primaryColor,
        title: const Text(
          "Profile",
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
              widget.userName.toUpperCase(),
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
              nextScreen(context, const HomePage());
            },
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
            onTap: () {},
            selected: true,
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
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(
              Icons.account_circle,
              size: 200,
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Full Name",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
                Text(
                  widget.userName.toUpperCase(),
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Constant.primaryColor),
                ),
              ],
            ),
            const Divider(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Email",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
                Text(
                  widget.email,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Constant.primaryColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
