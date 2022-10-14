import 'package:chatapp/services/database_srvices.dart';
import 'package:chatapp/shared/constant.dart';
import 'package:chatapp/shared/widget.dart';
import 'package:chatapp/view/home_page.dart';
import 'package:chatapp/view/registration_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../helper/helper_function.dart';
import '../services/auth_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formkey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool _isloading = false;
  AuthServices authServices = AuthServices();
  login() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        _isloading = true;
      });
      await authServices
          .loginWithEmailAndPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot = await DatabaseServices(
                  uid: FirebaseAuth.instance.currentUser!.uid)
              .gettingUserData(email);
          await HelperFunction.saveUserLoggedInStatus(true);
          await HelperFunction.saveUserName(snapshot.docs[0]['fullName']);
          await HelperFunction.saveUserEmail(email);
          nextScreenReplace(context, const HomePage());
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            _isloading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(color: Constant.primaryColor),
            )
          : SingleChildScrollView(
              child: Form(
                  key: formkey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 80),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Image.asset(
                            "assets/logo.png",
                            width: 80,
                          ),
                        ),
                        const Text(
                          "Login Now To See What They Are Talking!",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w700),
                        ),
                        Image.asset(
                          "assets/login.png",
                          height: 300,
                        ),
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                          validator: (value) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value!)
                                ? null
                                : "please Enter a Valid Email";
                          },
                          decoration: textInputDecoration.copyWith(
                              labelText: "Email",
                              prefixIcon: Icon(
                                Icons.email,
                                color: Constant.primaryColor,
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.length < 6) {
                              return "Password is too short";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                          obscureText: true,
                          decoration: textInputDecoration.copyWith(
                              labelText: "Password",
                              prefixIcon: Icon(
                                Icons.key,
                                color: Constant.primaryColor,
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 200,
                          height: 45,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Constant.primaryColor,
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25))),
                              onPressed: () {
                                login();
                              },
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w700),
                              )),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            ),
                            InkWell(
                              onTap: () {
                                nextScreen(context, const RegistrationPage());
                              },
                              child: Text(
                                "SignUp",
                                style: TextStyle(
                                    color: Constant.primaryColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
            ),
    );
  }
}
