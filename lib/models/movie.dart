class Movie {

  int id;
  String name;
  String img;
  String author;
  String year;
  bool status;

  Movie();

  Movie.fromMap(Map map){
    id = map["idColumn"];
    name = map["nameColumn"];
    img = map["imgColumn"];
    author = map["authorColumn"];
    year = map["yearColumn"];
    status = map["statusColumn"] == 1 ? true : false;
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "nameColumn": name,
      "imgColumn" : img,
      "authorColumn": author,
      "yearColumn": year,
      "statusColumn": status == false ? 0 : 1,
    };
    if(id != null){
      map["idColumn"] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Contact(id: $id, name: $name, img: $img, author: $author, year: $year, status: $status)";
  }
}