// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_p/providers/firebase_provider.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';

class CardProduct extends StatefulWidget {
  const CardProduct({
    Key? key,
    required this.productDocument
  }) : super(key: key);
  
  final DocumentSnapshot productDocument;

  @override
  State<CardProduct> createState() => _CardProductState();
}

class _CardProductState extends State<CardProduct> {
  
  late FirebaseProvider _fbp;

  @override
  void initState() {
    super.initState();
    _fbp = FirebaseProvider();
  }
  
  @override
  Widget build(BuildContext context) {  
    
    final _card = Stack(
    alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: FadeInImage(
            placeholder: AssetImage('assets/activity_indicator.gif'),
            image: NetworkImage(widget.productDocument['imgprod']),
            fit: BoxFit.cover,
            fadeInDuration: Duration(milliseconds: 100),
            height: 230.0,
          ),
        ),
        Opacity(
          opacity: .6,
          child: Container(
            height: 55.0,
            color: Colors.black,
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(widget.productDocument['cveprod'], style: TextStyle(color: Colors.white, fontFamily: 'Nunito', fontWeight: FontWeight.w700),))
              ],
            ),
          ),
        )
      ],
    );
    return Container(
      margin: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        
      ),
      child: FocusedMenuHolder(
        menuWidth: MediaQuery.of(context).size.width*0.50,
        menuBoxDecoration: BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.all(Radius.circular(15.0))),
        onPressed: (){},
        menuItems: [
          FocusedMenuItem(title: Text("Editar"),trailingIcon: Icon(Icons.edit_rounded) ,onPressed: (){Navigator.pushNamed(context, '/edit', arguments: { 'cveprod':widget.productDocument['cveprod'], 'descprod':widget.productDocument['descprod'], 'imgprod':widget.productDocument['imgprod'], 'DocumentID':widget.productDocument.id});}),
          FocusedMenuItem(title: Text("Borrar",style: TextStyle(color: Colors.redAccent),),trailingIcon: Icon(Icons.delete,color: Colors.redAccent,) ,onPressed: (){  print(widget.productDocument.id); _fbp.deleteProduct(widget.productDocument.id); setState(() {
            
          });})
        ],
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white,
                    boxShadow: [BoxShadow(
                      color: Color(0xff664B8D),
                      offset: Offset(1.0, 2.3),
                      blurRadius: 2.5
                    )]
                  ),
              //margin: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                        child: Image(
                            fit: BoxFit.cover,
                            image: NetworkImage(widget.productDocument['imgprod']),
                        width: 160,
                        height: 160,
                        )
                    ),
                    Container( //INFORMACION BASICA DE LA PELICULA
                      //padding: EdgeInsets.,
                        margin: EdgeInsets.only(left: 20, right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(width: 160, child: Text(widget.productDocument['cveprod'], style: TextStyle(color: Colors.black, fontFamily: 'Nunito', fontWeight: FontWeight.bold, fontSize: 15))),
                            Container( 
                              width: 160, 
                              child: Text(
                                widget.productDocument['descprod'],
                                maxLines: 3, 
                                overflow: TextOverflow.ellipsis, 
                                style: TextStyle(
                                  color: Colors.grey, 
                                  fontFamily: 'Nunito',
                                  fontSize: 11
                                  )
                                )
                            ),
                          ]
                        )
                    )
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}