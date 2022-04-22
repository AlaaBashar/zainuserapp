class MinistriesModel{
  String? id ;
  String? imageUrl ;
  String? title ;
  bool? isVisible ;

  MinistriesModel({this.id, this.imageUrl, this.title, this.isVisible });

  factory MinistriesModel.fromJson(Map<String, dynamic> json) {
    return MinistriesModel(
      id: json["id"],
        imageUrl: json["imageUrl"],
      title: json["title"],
      isVisible: json["isVisible"] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "imageUrl": imageUrl,
      "title": title,
      "isVisible": isVisible ?? true,
    };
  }
}