class ProductoDAO {
  String? cveprod;
  String? descprod;
  String? imgprod;

  ProductoDAO({this.cveprod, this.descprod, this.imgprod});

  Map<String, dynamic> toMap(){
    return {
      'cveprod' : cveprod,
      'descprod' : descprod,
      'imgprod' : imgprod
    };
  }

}