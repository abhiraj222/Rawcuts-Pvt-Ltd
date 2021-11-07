// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rawcuts_pvt_ltd/Constants/colors.dart';
import 'package:rawcuts_pvt_ltd/Constants/style.dart';
import 'package:rawcuts_pvt_ltd/Screens/mainscreen.dart';
import 'package:rawcuts_pvt_ltd/Services/global_method.dart';

import 'package:rawcuts_pvt_ltd/Widgets/rounded_button.dart';

class SignUpPage extends StatefulWidget {
  static const String id = 'sign_up_page';

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phNoController = TextEditingController();
  String _name = '';
  String _email = '';
  int _phNo;
  String _password = '';
  GlobalMethods _globalMethods = GlobalMethods();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    var date = DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Stack(
        children: [
          // BackgroundImage(
          //   backgroundImage: 'assets/images/register_bg.png',
          // ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      child: Center(
                        child: PrimaryText(
                          text: 'Welcome To \n    RawCuts!',
                          color: AppColors.primary,
                          size: 40,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: size.height * 0.08,
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.grey[500].withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextFormField(
                        controller: nameController,
                        key: ValueKey('name'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Enter your name';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Icon(
                              FontAwesomeIcons.user,
                              size: 30,
                              color: AppColors.primary,
                            ),
                          ),
                          labelText: 'Name',
                          labelStyle: TextStyle(
                              fontSize: 20, color: Colors.orangeAccent),
                        ),
                        style: TextStyle(color: Colors.white),
                        onSaved: (value) {
                          _name = value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Container(
                        height: size.height * 0.08,
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                          color: Colors.grey[500].withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextFormField(
                          key: ValueKey('Email'),
                          controller: emailController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Enter your email';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Icon(
                                FontAwesomeIcons.envelope,
                                size: 30,
                                color: AppColors.primary,
                              ),
                            ),
                            labelText: 'Email Address',
                            labelStyle: TextStyle(
                                fontSize: 20, color: Colors.orangeAccent),
                          ),
                          style: TextStyle(color: Colors.white),
                          onSaved: (value) {
                            _email = value;
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Container(
                        height: size.height * 0.08,
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                          color: Colors.grey[500].withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextFormField(
                          key: ValueKey('Phone Number'),
                          controller: phNoController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Enter your Phone Number';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Icon(
                                FontAwesomeIcons.phoneAlt,
                                size: 30,
                                color: AppColors.primary,
                              ),
                            ),
                            labelText: 'Phone Number',
                            labelStyle: TextStyle(
                                fontSize: 20, color: Colors.orangeAccent),
                          ),
                          style: TextStyle(color: Colors.white),
                          onSaved: (value) {
                            _phNo = int.parse(value);
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Container(
                        height: size.height * 0.08,
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                          color: Colors.grey[500].withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextFormField(
                          key: ValueKey('Password'),
                          controller: passwordController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Enter your email';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Icon(
                                FontAwesomeIcons.userLock,
                                size: 30,
                                color: AppColors.primary,
                              ),
                            ),
                            labelText: 'Password',
                            labelStyle: TextStyle(
                                fontSize: 20, color: Colors.orangeAccent),
                          ),
                          style: TextStyle(color: Colors.white),
                          onSaved: (value) {
                            _password = value;
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      height: size.height * 0.08,
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppColors.primary),
                      // ignore: deprecated_member_use
                      child: _isLoading
                          ? Center(child: CircularProgressIndicator())
                          : TextButton(
                              onPressed: () async {
                                final isValid =
                                    _formKey.currentState.validate();
                                if (isValid) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  _formKey.currentState.save();
                                  try {
                                    await _auth.createUserWithEmailAndPassword(
                                        email: _email.toLowerCase().trim(),
                                        password: _password.trim());
                                    final User user = _auth.currentUser;
                                    final _uid = user.uid;
                                    await FirebaseFirestore.instance
                                        .collection('Users')
                                        .doc(_uid)
                                        .set({
                                      'id': _uid,
                                      'Name': _name,
                                      'Email': _email,
                                      'phNo': _phNo,
                                      'joinedAt': formattedDate,
                                      'createdAt': Timestamp.now(),
                                    });
                                    Navigator.pushNamed(context, MainScreen.id);
                                  } catch (e) {
                                    _globalMethods.authErroHandle(
                                        e.message, context);
                                    print('error ocuured ${e.message}');
                                  } finally {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                }
                              },
                              child: PrimaryText(
                                text: 'Register',
                                fontWeight: FontWeight.w500,
                                color: AppColors.black,
                                size: 22,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
