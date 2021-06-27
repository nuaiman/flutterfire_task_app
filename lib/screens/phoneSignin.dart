import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_task_app/screens/loginScreen.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class PhoneSignIn extends StatefulWidget {
  @override
  _PhoneSignInState createState() => _PhoneSignInState();
}

class _PhoneSignInState extends State<PhoneSignIn> {
  PhoneNumber? phoneNumber;

  String? _message;
  String? _verificationId;

  bool _isSMSSent = false;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final _smsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ),
            );
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.indigo,
          ),
        ),
      ),
      body: SafeArea(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: _isSMSSent
                    ? TextFormField(
                        controller: _smsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'O T P',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                        ),
                      )
                    : IntlPhoneField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                        ),
                        onChanged: (phone) {
                          setState(() {
                            phoneNumber = phone;
                          });
                          print(phone.completeNumber);
                        },
                        onCountryChanged: (phone) {
                          setState(() {
                            phoneNumber = phone;
                          });
                        },
                      ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 50),
                width: double.infinity,
                child: _isSMSSent
                    ? ElevatedButton(
                        child: Text('V E R I F Y'),
                        onPressed: () {
                          setState(() {
                            _isSMSSent = false;
                          });
                        },
                      )
                    : ElevatedButton.icon(
                        icon: Icon(Icons.send),
                        label: Text('O T P'),
                        onPressed: () {
                          setState(() {
                            _isSMSSent = true;
                          });
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
