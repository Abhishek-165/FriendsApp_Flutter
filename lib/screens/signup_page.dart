import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:friends/Database/database_helper.dart';
import 'package:friends/utils/navigation.dart';
import 'package:friends/utils/widgets.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  var fname = '';
  var lname = '';
  var email = '';
  var phone = '';
  var password = '';

  var db = DatabaseHelper.instance;
  Future<void> _saveForm() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    //if number and referal are same then show error
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    db
        .insertUser({
          DatabaseHelper.columnFName: fname,
          DatabaseHelper.columnLName: lname,
          DatabaseHelper.columnEmail: email,
          DatabaseHelper.columnPhone: phone,
          DatabaseHelper.columnPassword: password,
        })
        .then((value) => Navigator.pushReplacement(context, loginPageRouter()))
        .catchError((e, s) => customToast("Field is missing!"));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        elevation: 0,
        backgroundColor: Colors.white10,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    "Create",
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Account",
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      fillColor: Color.fromRGBO(230, 230, 230, 1),
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(230, 230, 230, 1)),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      hintText: 'First Name',
                      hintStyle: TextStyle(
                        fontFamily: 'SourceSansPro',
                        fontSize: 14,
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please provide a First Name.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      fname = value;
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      fillColor: Color.fromRGBO(230, 230, 230, 1),
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(230, 230, 230, 1)),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      hintText: 'Last Name',
                      hintStyle: TextStyle(
                        fontFamily: 'SourceSansPro',
                        fontSize: 14,
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please provide a Last Name.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      lname = value;
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    maxLines: null,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      fillColor: Color.fromRGBO(230, 230, 230, 1),
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(230, 230, 230, 1)),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      hintText: 'Email',
                      hintStyle: TextStyle(
                        fontFamily: 'SourceSansPro',
                        fontSize: 14,
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please provide an email';
                      }
                      //check if the email is valid
                      RegExp regExp = new RegExp(
                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                      if (!regExp.hasMatch(value)) {
                        return 'Invalid email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      email = value;
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    maxLines: null,
                    decoration: InputDecoration(
                      fillColor: Color.fromRGBO(230, 230, 230, 1),
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(230, 230, 230, 1)),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      hintText: 'Phone',
                      hintStyle: TextStyle(
                        fontFamily: 'SourceSansPro',
                        fontSize: 14,
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please provide a mobile no.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      phone = value.toString();
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      fillColor: Color.fromRGBO(230, 230, 230, 1),
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 0,
                            color: Color.fromRGBO(230, 230, 230, 1)),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      hintText: 'Password',
                      hintStyle: TextStyle(
                        fontFamily: 'SourceSansPro',
                        fontSize: 14,
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please provide a password.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      password = value;
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 32,
                        ),
                      ),
                      InkWell(
                        onTap: _saveForm,
                        child: Container(
                            height: 60,
                            width: 60,
                            child: _isLoading
                                ? CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                  )
                                : Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                  ),
                            decoration: BoxDecoration(
                              color: Colors.blue[300],
                              borderRadius: BorderRadius.circular(30.0),
                            )),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: "By Continuing you agree to our ",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              )),
                          TextSpan(
                              text: "Terms and Conditions ",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.blue,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {}),
                        ])),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, loginPageRouter());
                    },
                    child: Container(
                      alignment: Alignment.bottomRight,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Sign In",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: 60,
                            color: Colors.blue[300],
                            height: 2,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
