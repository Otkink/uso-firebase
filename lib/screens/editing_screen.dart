// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:firebase_p/models/product_dao.dart';
import 'package:firebase_p/providers/firebase_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/tap_bounce_container.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class EditingScreen extends StatefulWidget {
  EditingScreen({Key? key}) : super(key: key);

  @override
  _EditingScreenState createState() => _EditingScreenState();
}

class _EditingScreenState extends State<EditingScreen> {

  TextEditingController _txtName = TextEditingController();
  TextEditingController _txtDsc = TextEditingController();
  late FirebaseProvider _fbp;
  var docid = ''; //guarda el id del documento (es el id del registro)

  File? image;
  String url = '';
  bool img_hasChanged = false;
  Future pickImage() async{ //metodo para escoger la imagen de la Galeria
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null){
        print("Cancele la accion");
        return;
      } else{
        final imageTemporary = File(image.path);
        img_hasChanged = true; //si ingresa aqui es porque selecciono otra foto, de esta forma el hecho de que abra el ImagePicker no significa que se haya modificado la imagen hasta que realmente haya seleccionado alguna
        //setState(() { }); //actualiza la pagina para que aparezca la nueva imagen
        setState(() => this.image = imageTemporary ); //se guarda la ruta temporal en la variable File? image;
      }
    } on PlatformException catch (e) {
      print('Seleccion de imagen fallida: $e');
    }
  }

  Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fbp = FirebaseProvider();
  }

  @override
  Widget build(BuildContext context) {
    final shinamono = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>; //cone sta instruccion es posible recuperar los parametros enviados en el Navigator.pushNamed(..., arguments:"...")
    
    _txtName.text = shinamono['cveprod'];
    _txtDsc.text = shinamono['descprod'];
    url = shinamono['imgprod'];

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomLeft, end: Alignment.topRight,
              // ignore: prefer_const_literals_to_create_immutables
              colors: [Color(0xff664B8D), 
              Color(0xff402460)])),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            title: Text("Editar producto", style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w900, fontSize: 25)),
          ),
          backgroundColor: Colors.transparent,
          body: ListView(padding: EdgeInsets.zero, 
            physics: BouncingScrollPhysics(),
            children: [
            SizedBox(height: 50),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(left: 30),
                  child: Text("Nombre:",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontFamily: 'Nunito', fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal:
                          50), //limito el tamano del UnderlineInputBorder
                  child: TextFormField(
                    controller: _txtName,
                    //textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Nunito', 
                      fontWeight: FontWeight.normal
                    ),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: "Ingrese el nombre",
                        hintStyle: TextStyle(
                          color: Colors.white12,
                          fontFamily: 'Nunito', 
                          fontWeight: FontWeight.normal
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white24,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54, width: 2),
                        ),
                        //border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 5)),
                    onChanged: (text) {
                      //tmpNombre = text;
                      // _hasChanged = true;
                    },
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  margin: EdgeInsets.only(left: 30),
                  child: Text("Descripción:",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontFamily: 'Nunito', fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal:
                          50), //limito el tamano del UnderlineInputBorder
                  child: TextFormField(
                    minLines: 6, // any number you need (It works as the rows for the textarea)
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    controller: _txtDsc,
                    //textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Nunito', 
                      fontWeight: FontWeight.normal
                    ),
                    decoration: InputDecoration(
                        hintText: "Información del producto",
                        hintStyle: TextStyle(
                          color: Colors.white12,
                          fontFamily: 'Nunito', 
                          fontWeight: FontWeight.normal
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white24,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54, width: 2),
                        ),
                        //border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 5)),
                    onChanged: (text) {
                      //tmpNombre = text;
                      // _hasChanged = true;
                    },
                  ),
                )
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Container(
                  margin: EdgeInsets.only(left: 30),
                  child: Text("Seleccionar foto:",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontFamily: 'Nunito', fontWeight: FontWeight.bold)),
                ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: (){
                pickImage();
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50.0),
                        bottomLeft: Radius.circular(50.0)),
                  image: DecorationImage(
                    image: image == null ? 
                      NetworkImage(shinamono['imgprod'])
                      : FileImage(image!) as ImageProvider,
                    fit: BoxFit.cover
                  )
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                    FlatButton(
                      highlightColor: Colors.white24,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      onPressed: () {
                          String desc = _txtDsc.text;
                          Navigator.pop(context);
                      },
                        child:Text("Descartar", style: TextStyle(color: Colors.white, fontSize: 15, fontFamily: 'Nunito', fontWeight: FontWeight.w200))),
                    RaisedButton(
                        color: Colors.white,
                        highlightColor: Colors.white54,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        onPressed: () async { //Valida si es posible realizar la insercion
                          if(image != null || url !='' && _txtName.text != '' && _txtDsc.text != ''){//las dos variables txt deben contener texto para que pueda realizarse el update y el file image debe contener el path
                            docid = shinamono['DocumentID'];//le asigno el valor del id para que sea utilizada por los metodos fuera del context
                            await uploadStatusImage().whenComplete(() {
                              Navigator.pop(context);
                              showTopSnackBar(
                                  context,
                                  CustomSnackBar.success(
                                    message:
                                        "Producto actualizado",
                                  ),
                              );
                            });
                          }else{
                            if(image == null && _txtName.text == '' && _txtDsc.text == ''){
                              showTopSnackBar(
                                  context,
                                  CustomSnackBar.error(
                                    message:
                                        "Rellene todos los campos",
                                  ),
                              );
                            }else{
                              if(image == null){
                                showTopSnackBar(
                                  context,
                                  CustomSnackBar.error(
                                    message:
                                        "Agregue una imagen",
                                  ),
                                );
                              }else{
                                showTopSnackBar(
                                  context,
                                  CustomSnackBar.error(
                                    message:
                                        "Rellene todos los campos",
                                  ),
                                );
                              }
                            }
                          }
                        },
                        child: Text("Actualizar",
                            style: TextStyle(
                                color: Color(0xff664B8D), fontSize: 20, fontFamily: 'Nunito', fontWeight: FontWeight.bold))),
                  ],
            )
          ])),
    );
  }

  Future<void> uploadStatusImage() async {
    await Firebase.initializeApp();
    
    if(img_hasChanged){ //si la imagen fue cambiada, entonces la subira a Storage y luego actualizara el registro
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('Product Images');
      var timeKey = DateTime.now();
      final imageName = (timeKey.toString()+".jpg");
      UploadTask uploadTask = ref.child(timeKey.toString() + '.jpg').putFile(image!); //Caso en el que es elija una nueva imagen la sube a Storage
      
      uploadTask.whenComplete(() async {
        url = await ref.child(imageName).getDownloadURL();
        print(url.toString());
        await updateInFirebase(url.toString(), docid);
      }).catchError((onError) {
        print(onError);
      });
    }else{ //si la imagen no fue cambiada, entonces simplemente toma la url de la imagen inicial y luego actualiza el registro
      await updateInFirebase(url, docid);
    }
  }

  Future<void> updateInFirebase(String image_url, docid) async {
    ProductoDAO producto = ProductoDAO(
      cveprod: _txtName.text,
      descprod: _txtDsc.text,
      imgprod: image_url
    );
    await _fbp.updateProduct(producto, docid);
  }
}