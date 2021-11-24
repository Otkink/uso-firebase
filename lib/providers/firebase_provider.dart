import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_p/models/product_dao.dart';

class FirebaseProvider {
  late FirebaseFirestore _firestore;
  late CollectionReference _produtcsCollection;

  FirebaseProvider(){
    _firestore = FirebaseFirestore.instance;
    _produtcsCollection = _firestore.collection('shinamono');
  }

  Future<void> saveProduct(ProductoDAO objPDAO) => _produtcsCollection.add(objPDAO.toMap());

  Future<void> updateProduct(ProductoDAO objPDAO, String DocumentID){
    return _produtcsCollection.doc(DocumentID).update(objPDAO.toMap());
  }

  Future<void> deleteProduct(String DocumentID){
    return _produtcsCollection.doc(DocumentID).delete();
  }

  Stream<QuerySnapshot> getAllProducts(){
    return _produtcsCollection.snapshots();
  }
}