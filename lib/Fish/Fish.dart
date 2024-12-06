class Fish {
  late String id;
  late String typePoisson;
  late String imageUrl;
  late String localisation;

  Fish(this.id,
      {required this.typePoisson,
      required this.imageUrl,
      required this.localisation});

  Fish.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    typePoisson = json['typePoisson'];
    imageUrl = json['imageUrl'];
    localisation = json['localisation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['typePoisson'] = typePoisson;
    data['imageUrl'] = imageUrl;
    data['localisation'] = localisation;
    return data;
  }
}
