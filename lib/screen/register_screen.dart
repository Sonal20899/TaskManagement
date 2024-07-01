import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management/screen/login_screen.dart';

import '../components/shared_key/shared_key.dart';
import '../ui/dialogbox/dialogbox_screen.dart';
import '../ui/mycolor.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  final RegExp _email = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  String errmsg = '';
  bool eye = true;
  bool eye1 = true;
  void openEye() {
    setState(() {
      eye = !eye;
    });
  }

  void confirmEye() {
    setState(() {
      eye1 = !eye1;
    });
  }

  void showloader() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  void hideloader() {
    Navigator.of(context).pop();
  }

  void createuser() async {
    if (name.text.isEmpty) {
      quickalert(context, "Enter your name", QuickAlertType.warning);
    } else if (email.text.isEmpty) {
      quickalert(context, "Enter your email", QuickAlertType.warning);
    } else if (password.text.isEmpty) {
      quickalert(context, "Enter your password", QuickAlertType.warning);
    } else if (mobile.text.isEmpty) {
      quickalert(context, "Enter your mobile no", QuickAlertType.warning);
    } else if (confirmPassword.text.isEmpty) {
      quickalert(context, "Confirm your password", QuickAlertType.warning);
    } else {
      showloader();
      try {
        UserCredential newUser = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: email.text.trim(), password: password.text.trim());

        if (newUser.user != null) {
          hideloader();
          String userName = name.text;
          String userEmail = email.text;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(SharedKey.userName, userName);
          prefs.setString(SharedKey.userEmail, userEmail);
          await FirebaseFirestore.instance.collection(name.text.trim());

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LoginPage(profile_name: name.text)));
          quickalert(context, "User Created", QuickAlertType.success);
        }
      } on FirebaseAuthException catch (e) {
        hideloader();
        showalert(context, e.code.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Container(
        height: size.height * 1,
        width: size.width * 1,
        color: backgroundColor,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.08),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Welcome to Onboard !",
                    style: GoogleFonts.actor(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 5),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Let's help to meet up your Task",
                    style: GoogleFonts.inter(
                        fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(height: size.height * 0.07),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 10, horizontal: size.width * 0.06),
                  child: TextField(
                    style: GoogleFonts.inter(
                        fontSize: 15, fontWeight: FontWeight.w400),
                    controller: name,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20)),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Enter your full name',
                      hintStyle: GoogleFonts.kufam(
                          fontSize: 13, fontWeight: FontWeight.w400),
                      prefixIcon: const Icon(Icons.person,
                          color: Colors.grey, size: 18),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 10, horizontal: size.width * 0.06),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        if (_email.hasMatch(value)) {
                          errmsg = '';
                        } else {
                          errmsg = 'Enter valide email address';
                        }
                      });
                    },
                    style: GoogleFonts.inter(
                        fontSize: 15, fontWeight: FontWeight.w400),
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20)),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Enter your email',
                      hintStyle: GoogleFonts.kufam(
                          fontSize: 13, fontWeight: FontWeight.w400),
                      prefixIcon:
                          const Icon(Icons.email, color: Colors.grey, size: 18),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 10, horizontal: size.width * 0.06),
                  child: TextField(
                    style: GoogleFonts.inter(
                        fontSize: 15, fontWeight: FontWeight.w400),
                    controller: mobile,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20)),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Enter your mobile no',
                      hintStyle: GoogleFonts.kufam(
                          fontSize: 13, fontWeight: FontWeight.w400),
                      prefixIcon:
                          const Icon(Icons.call, color: Colors.grey, size: 18),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 10, horizontal: size.width * 0.06),
                  child: TextField(
                    style: GoogleFonts.inter(
                        fontSize: 15, fontWeight: FontWeight.w400),
                    controller: password,
                    obscureText: eye,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20)),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Enter password',
                      hintStyle: GoogleFonts.kufam(
                          fontSize: 13, fontWeight: FontWeight.w400),
                      prefixIcon:
                          const Icon(Icons.key, color: Colors.grey, size: 18),
                      suffixIcon: IconButton(
                          onPressed: () {
                            openEye();
                          },
                          icon: Icon(
                            eye ? Icons.visibility_off : Icons.visibility,
                            size: 18,
                            color: Colors.grey,
                          )),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 10, horizontal: size.width * 0.06),
                  child: TextField(
                    obscureText: eye1,
                    style: GoogleFonts.inter(
                        fontSize: 15, fontWeight: FontWeight.w400),
                    controller: confirmPassword,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20)),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Confirm password',
                      hintStyle: GoogleFonts.kufam(
                          fontSize: 13, fontWeight: FontWeight.w400),
                      prefixIcon:
                          const Icon(Icons.key, color: Colors.grey, size: 18),
                      suffixIcon: IconButton(
                          onPressed: () {
                            confirmEye();
                          },
                          icon: Icon(
                            eye1 ? Icons.visibility_off : Icons.visibility,
                            size: 18,
                            color: Colors.grey,
                          )),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.1),
                  child: GestureDetector(
                    onTap: () {
                      createuser();
                    },
                    child: Container(
                      height: 45,
                      width: size.width * 0.85,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: Text(
                          "Register",
                          style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account ? ",
                        style: GoogleFonts.lato(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(
                                  profile_name: name.text,
                                ),
                              ));
                        },
                        child: Text(
                          "Login",
                          style: GoogleFonts.lato(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
