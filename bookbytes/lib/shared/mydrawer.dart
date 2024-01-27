import 'package:bookbytes/views/communitypage.dart';
import 'package:bookbytes/views/loginpage.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../views/mainpage.dart';
import '../views/profilepage.dart';
import 'EnterExitRoute.dart';

class MyDrawer extends StatefulWidget {
  final String page;
  final User userdata;

  const MyDrawer({Key? key, required this.page, required this.userdata})
      : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.deepOrange,
            ),
            currentAccountPicture: const CircleAvatar(
                foregroundImage: AssetImage('assets/images/profile.png'),
                backgroundColor: Colors.white),
            accountName: Text(widget.userdata.username.toString()),
            accountEmail: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.userdata.useremail.toString()),
                    const Text("Registered") //RM100
                  ]),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Books'),
            onTap: () {
              Navigator.pop(context);
              if (widget.page.toString() == "books") {
                return;
              }
              Navigator.pop(context);
              Navigator.push(
                  context,
                  EnterExitRoute(
                      exitPage: MainPage(
                        userdata: widget.userdata,
                      ),
                      enterPage: MainPage(userdata: widget.userdata)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Community'),
            onTap: () {
              Navigator.pop(context);
              if (widget.page.toString() == "community") {
                return;
              }
              Navigator.pop(context);
              Navigator.push(
                  context,
                  EnterExitRoute(
                      exitPage: CommunityPage(userdata: widget.userdata),
                      enterPage: CommunityPage(userdata: widget.userdata)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text('My Account'),
            onTap: () {
              Navigator.pop(context);
              if (widget.page.toString() == "account") {
                return;
              }
              Navigator.pop(context);
              Navigator.push(
                  context,
                  EnterExitRoute(
                      exitPage: ProfilePage(userdata: widget.userdata),
                      enterPage: ProfilePage(userdata: widget.userdata)));
            },
          ),
          const Divider(
            color: Colors.black,
          ),
          /*ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              //Navigator.pop(context);
            },
          ),*/
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              if (widget.page.toString() == "logout") {
                return;
              }
              Navigator.pop(context);
              Navigator.push(
                  context,
                  EnterExitRoute(
                      exitPage: const LoginPage(),
                      enterPage: const LoginPage()));
            },
          ),
        ],
      ),
    );
  }
}
