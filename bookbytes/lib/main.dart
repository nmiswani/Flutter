import 'package:flutter/material.dart';
import 'package:bookbytes/views/splashpage.dart';
import 'package:bookbytes/views/loginpage.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 70),
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
                    style: TextStyle(color: Colors.grey[700], fontSize: 16),
                  ),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2.5,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/welcomepage.jpg'),
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width /
                        2.5, // Set the width of the button
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      },
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(60)),
                      child: const Text(
                        "Let's start",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Removed the "Sign up" button
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
