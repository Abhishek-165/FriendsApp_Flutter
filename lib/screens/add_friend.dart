import 'package:flutter/material.dart';
import 'package:friends/Database/database_helper.dart';
import 'package:friends/utils/navigation.dart';
import 'package:friends/utils/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddFriend extends StatefulWidget {
  const AddFriend({Key key}) : super(key: key);

  @override
  _AddFriendState createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  var fname = '';
  var lname = '';
  var email = '';
  var phone = '';

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

    await DatabaseHelper.instance.insertFriend({
      DatabaseHelper.columnFName: fname,
      DatabaseHelper.columnLName: lname,
      DatabaseHelper.columnEmail: email,
      DatabaseHelper.columnPhone: phone,
      DatabaseHelper.refNo: prefs.getString("number")
    }).then((value) {
      customToast("Friend Added successfully!");
      Navigator.push(context, friendsPageRouter());
    }).onError((error, stack) => customToast("User doesn't exists"));

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
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
                    "Add Friend",
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.20,
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
                      hintText: "Friend's First Name",
                      hintStyle: TextStyle(
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
                            width: 0,
                            color: Color.fromRGBO(230, 230, 230, 1)),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      hintText: "Friend's Last Name",
                      hintStyle: TextStyle(
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
                      lname = value;
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
                      hintText: "Friend's Email",
                      hintStyle: TextStyle(
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
                      email = value;
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    maxLines: null,
                    textInputAction: TextInputAction.done,
                    maxLength: 10,
                    decoration: InputDecoration(
                      fillColor: Color.fromRGBO(230, 230, 230, 1),
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 0,
                            color: Color.fromRGBO(230, 230, 230, 1)),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      hintText: "Friend's Phone",
                      hintStyle: TextStyle(
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
                      phone = value.toString();
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Continue",
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
