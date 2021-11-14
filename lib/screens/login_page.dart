
import 'package:flutter/material.dart';
import 'package:friends/Database/database_helper.dart';
import 'package:friends/utils/navigation.dart';
import 'package:friends/utils/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    initiateDb();
    super.initState();
  }

  var db;

  Future initiateDb() async {
    db = DatabaseHelper.instance;
  }

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  var phone = '';
  var password = '';
  Future<void> _saveForm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    //if number and referal are same then show error
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    db = await DatabaseHelper.instance.getuser(phone, password).then((value) {
      if (value.length > 0) {
        prefs.setString("number", phone);
        customToast("Logged In Successfully!");
        Navigator.pushReplacement(context, friendsPageRouter());
      } else {
        customToast("User doesn't exists");
      }
    }).onError((error, stack) => customToast("Something Went Wrong"));

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
          child: Form(
            key: _formKey,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    "Welcome",
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Back",
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.25,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    maxLines: null,
                    maxLength: 10,
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
                      phone = value;
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
                    height: MediaQuery.of(context).size.width * 0.1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Sign In",
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
                    height: MediaQuery.of(context).size.width * 0.2,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, signUpPageRouter());
                    },
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Sign Up",
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
