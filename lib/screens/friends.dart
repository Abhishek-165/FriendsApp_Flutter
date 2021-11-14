import 'package:flutter/material.dart';
import 'package:friends/Database/database_helper.dart';
import 'package:friends/models/user.dart';
import 'package:friends/utils/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Friends extends StatefulWidget {
  const Friends({Key key}) : super(key: key);

  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  var _editingController = TextEditingController();

  List<Map<String, dynamic>> friendsList;

  int totalFriends = 0;
  List<Friend> data = [];
  Future<List> _getValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    data.clear();
    print(prefs.getString("number"));
    friendsList =
        await DatabaseHelper.instance.getFriends(prefs.getString("number"));
    friendsList.forEach((element) {
      Friend task = Friend(element["_id"], element["_fname"], element["_lname"],
          element["_email"], element["_phone"], element["_referenceNo"]);
      data.add(task);
    });
    totalFriends = data.length;
    return data;
  }

  List<Friend> searchResult = [];
  onSearchTextChanged(String text) {
    searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    friendsList.forEach((element) {
      if (element["_fname"].toLowerCase().contains(text.toLowerCase())) {
        Friend task = Friend(
            element["_id"],
            element["_fname"],
            element["_lname"],
            element["_email"],
            element["_phone"],
            element["_referenceNo"]);
        searchResult.add(task);
      }
    });

    setState(() {});
  }

  _delete(String phone) async {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Are you sure?"),
              actions: [
                TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await DatabaseHelper.instance.deleteQuery(phone);
                      setState(() {});
                    },
                    child: Text("Yes")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("No"))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: BottomSheet(
        onClosing: () {},
        builder: (context) => Row(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: _editingController,
                  onChanged: (input) {
                    print(input);
                    onSearchTextChanged(input);
                  },
                  decoration: new InputDecoration(
                    suffixIcon: GestureDetector(
                        child: Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
                        onTap: () {
                          _editingController.clear();
                          searchResult.clear();
                          onSearchTextChanged('');
                        }),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(30.0),
                      ),
                    ),
                    hintText: "Search Friends",
                    filled: true,
                    hintStyle: new TextStyle(
                      color: Colors.white70,
                    ),
                    fillColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, addFriendPageRouter());
              },
              child: Container(
                  margin: EdgeInsets.only(right: 5),
                  height: 60,
                  width: 60,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[300],
                    borderRadius: BorderRadius.circular(30.0),
                  )),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "My Friends",
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  totalFriends != 0
                      ? "${totalFriends.toString()} friends"
                      : "0 Friend",
                  style: TextStyle(
                    fontSize: 32,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.25,
              ),
              searchResult.length != 0 || _editingController.text.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                          itemCount: searchResult.length,
                          shrinkWrap: true,
                          itemBuilder: (context, i) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    editFriendPageRouter(
                                        searchResult[i].fname,
                                        searchResult[i].lname,
                                        searchResult[i].email,
                                        searchResult[i].phone,
                                        searchResult[i].refNo));
                              },
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(26),
                                  child:
                                      Image.asset("assets/images/icon.png"),
                                ),
                                title: Text(searchResult[i].fname ?? ''),
                                subtitle: Text(
                                    "I am a full stack software developer in protto"),
                                trailing: IconButton(
                                  onPressed: () =>
                                      _delete(searchResult[i].phone),
                                  icon: Icon(Icons.more_vert,
                                      color:
                                          Theme.of(context).primaryColor),
                                ),
                              ),
                            );
                          }),
                    )
                  : Expanded(
                      child: FutureBuilder(
                        future: _getValue(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.data == null) {
                            return CircularProgressIndicator();
                          } else {
                            return ListView.separated(
                                separatorBuilder: (context, i) => Divider(),
                                shrinkWrap: true,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, i) {
                                  if (snapshot.data.length == 0) {
                                    return Center(
                                        child: Text(
                                      "Add Friends",
                                      style: TextStyle(color: Colors.white),
                                    ));
                                  } else {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            editFriendPageRouter(
                                                snapshot.data[i].fname,
                                                snapshot.data[i].lname,
                                                snapshot.data[i].email,
                                                snapshot.data[i].phone,
                                                snapshot.data[i].refNo));
                                      },
                                      child: ListTile(
                                        leading: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(26),
                                          child: Image.asset(
                                              "assets/images/icon.png"),
                                        ),
                                        title: Text(
                                            snapshot.data[i].fname ?? ''),
                                        subtitle: Text(
                                            "I am a full stack software developer in protto"),
                                        trailing: IconButton(
                                          onPressed: () => _delete(
                                              snapshot.data[i].phone),
                                          icon: Icon(Icons.delete,
                                              size: 42,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                      ),
                                    );
                                  }
                                });
                          }
                        },
                      ),
                    ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
