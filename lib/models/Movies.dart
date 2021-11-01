// @dart=2.9

class Movie {

  static const tblContact = 'movies';
  static const colId = 'id';
  static const colEmail = 'email';
  static const colName = 'name';
  static const colDirector = 'director';
  static const colMovi = 'movi';

  Movie({this.id,this.name,this.director,this.email,this.movi});

   int id;
   String name;
   String director;
   String email;
   String movi;


  Movie.fromMap(Map<String, dynamic> map) {
    id = map[colId];
    name = map[colName];
    email = map[colEmail];
    director = map[colDirector];
    movi = map[colMovi];

  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{colName: name, colDirector: director, colEmail:email, colMovi:movi};
    if (id != null) {
      map[colId] = id;
    }
    return map;
  }
}