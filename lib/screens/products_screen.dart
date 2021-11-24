import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_p/providers/firebase_provider.dart';
import 'package:flutter/material.dart';

class ListProducts extends StatefulWidget {
  ListProducts({Key? key}) : super(key: key);

  @override
  _ListProductsState createState() => _ListProductsState();
}

class _ListProductsState extends State<ListProducts> {

  late FirebaseProvider _firebaseProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseProvider = FirebaseProvider();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firebaseProvider.getAllProducts(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if( !snapshot.hasData) return Center(child: CircularProgressIndicator());
        return ListView(
          children: [],
        );
      }
    );
  }
}