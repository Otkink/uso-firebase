import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_p/screens/products_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContexMaterialApp) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Firebase'),
          actions: [
            IconButton(onPressed: (){}, icon: Icon(Icons.add))
          ],
        ),
        body: ListProducts(),
      ),
    );
  }
}