// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'loginpage.dart';
//import '../models/user.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 80),
          color: Colors.white, // Set the background color to white
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  const Text(
                    "Welcome",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 38),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    " Explore, learn and immerse yourself in the world of knowledge through books.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[800], fontSize: 16),
                  ),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2.5,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/welcomepage.png'),
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Container(
                      padding: const EdgeInsets.only(top: 3, left: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: const Border(
                          bottom: BorderSide(color: Colors.black),
                          top: BorderSide(color: Colors.black),
                          left: BorderSide(color: Colors.black),
                          right: BorderSide(color: Colors.black),
                        ),
                      ),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: 50,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (content) => const LoginPage()));
                        },
                        color: Colors.deepOrangeAccent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Text(
                          "Let's Start",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.black, // Set text color to white
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
