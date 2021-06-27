import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_task_app/screens/phoneSignin.dart';
import 'package:flutterfire_task_app/screens/signupScreen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // User? user;

  // UserInfo? userInfo;

  // _signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleSignInAccount =
  //         await _googleSignIn.signIn();
  //     final GoogleSignInAuthentication? googleSignInAuthentication =
  //         await googleSignInAccount!.authentication;

  //     final AuthCredential authCredential = GoogleAuthProvider.credential(
  //       accessToken: googleSignInAuthentication!.accessToken,
  //       idToken: googleSignInAuthentication.idToken,
  //     );

  //     final User? user =
  //         (await _firebaseAuth.signInWithCredential(authCredential)).user;

  //     if (user != null) {
  //       await _firebaseFirestore.collection('users').doc(user.uid).set(
  //         {
  //           'email': user.email,
  //           'displayName': user.displayName,
  //           'photoUrl': user.photoURL,
  //           'lastSeen': DateTime.now(),
  //           'signin_method': user.providerData,
  //         },
  //       );
  //     }
  //   } catch (e) {
  //     showDialog(
  //       context: context,
  //       builder: (ctx) => AlertDialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(8),
  //         ),
  //         title: Text('Error'),
  //         content: Text(e.toString()),
  //         actions: [
  //           ElevatedButton(
  //             onPressed: () {
  //               Navigator.of(ctx).pop();
  //             },
  //             child: Text('Okay'),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  // }

  void _logIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      await _firebaseAuth
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) {
        setState(() {
          _isLoading = false;
        });
      }).catchError((e) {
        setState(() {
          _isLoading = false;
        });
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            title: Text('Error'),
            content: Text(e.toString()),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text('Okay'),
              ),
            ],
          ),
        );
      });
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          title: Text('Error'),
          content: Text('Please enter email & password'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('Okay'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final _deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 80),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      // color: Color(0xff00f58d),
                      color: Colors.blue,
                      blurRadius: 30,
                      offset: Offset(-50, -10),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      // color: Color(0xff006572),
                      color: Colors.indigo,
                      blurRadius: 30,
                      offset: Offset(60, -10),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Opacity(
                  opacity: 0,
                  child: FlutterLogo(
                    size: 200,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 50),
                child: Text(
                  'L O G I N',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: _emailController,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Email Address',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: _passwordController,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Password Address',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
              ),
              SizedBox(height: _deviceHeight * 0.025),
              _isLoading
                  ? LinearProgressIndicator()
                  : Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => SignupScreen(),
                                ),
                              );
                            },
                            child: Text('Or, Sign-up ?'),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _logIn,
                              child: Text('L O G I N'),
                            ),
                          ),
                        ],
                      ),
                    ),
              // SizedBox(height: _deviceHeight * 0.05),
              // _isLoading
              //     ? Container()
              //     : Container(
              //         padding: EdgeInsets.all(10),
              //         child: Row(
              //           children: [
              //             Expanded(
              //               child: ElevatedButton.icon(
              //                 onPressed: _signInWithGoogle,
              //                 icon: Icon(FontAwesomeIcons.google),
              //                 label: Text(''),
              //               ),
              //             ),
              //             SizedBox(width: 10),
              //             Expanded(
              //               child: ElevatedButton.icon(
              //                 onPressed: () {
              //                   Navigator.of(context).push(
              //                     MaterialPageRoute(
              //                       builder: (context) => PhoneSignIn(),
              //                     ),
              //                   );
              //                 },
              //                 icon: Icon(FontAwesomeIcons.phoneAlt),
              //                 label: Text(''),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
            ],
          ),
        ),
      ),
    );
  }
}
