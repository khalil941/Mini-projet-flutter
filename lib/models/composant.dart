class Composnat {
  late int id;
  late String title;
  late String qte;
  late String createdAt;

  Composnat({
    required this.id,
    required this.title,
    required this.qte,
    required this.createdAt,
  });

  Composnat.fromMap(dynamic obj) {
    this.id = obj['id'];
    this.title = obj['title'];
    this.qte=obj['qte'];
    this.createdAt=obj['createdAt'];

  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'title': title,
    };

    return map;
  }
}