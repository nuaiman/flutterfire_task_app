import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_task_app/screens/homeScreen.dart';
import 'package:flutterfire_task_app/screens/loginScreen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  UserCredential? userCredential;

  void _Signup() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      userCredential = await _auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((user) async {
        await _firebaseFirestore.collection('users').doc(user.user!.uid).set(
          {
            'email': email,
            'lastSeen': Timestamp.now(),
            'signin_method': user.additionalUserInfo!.providerId,
          },
        );
        setState(() {
          _isLoading = false;
        });
        setState(() {});
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
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
                  'S I G N U P',
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
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            },
                            child: Text('Or, Log-in ?'),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _Signup,
                              child: Text('S I G N U P'),
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
              //                 onPressed: () {},
              //                 icon: Icon(FontAwesomeIcons.google),
              //                 label: Text(''),
              //               ),
              //             ),
              //             SizedBox(width: 10),
              //             Expanded(
              //               child: ElevatedButton.icon(
              //                 onPressed: () {},
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
