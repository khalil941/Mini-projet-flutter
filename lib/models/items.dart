class Items {
  late int id;
  late String Title;
  late String description;

  Items({
    required this.id,
    required this.Title,
  });

  Items.fromMap(dynamic obj) {
    this.id = obj['id'];
    this.Title = obj['Title'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'Title': Title,
    };

    return map;
  }
}