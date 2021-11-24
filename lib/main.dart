import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_p/screens/adding_screen.dart';
import 'package:firebase_p/screens/products_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(//The problem was, MyApp was actually a parent of MaterialApp. As it was the widget who instantiated MaterialApp! Therefore MyApp's BuildContext didn't have a MaterialApp as parent! To solve this problem, we need to use a different context.
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Firebase'), 
              actions: [
                IconButton(onPressed: (){
                  Navigator.pushNamed(context, '/add');
                }, 
                  icon: Icon(Icons.add))
              ],
            ),
            body: ListProducts(),
          );
        }
      ),
      routes: {
        "/add": (BuildContext context) => AddingScreen()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}