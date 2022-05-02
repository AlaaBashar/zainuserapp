class OffersModel{

  String? price;
  String? speed;
  String? id;
  bool? isAvailable;


  OffersModel({this.price, this.speed,this.id,this.isAvailable});


  factory OffersModel.fromJson(Map<String, dynamic> json) {
    return OffersModel(
      price: json["price"],
      speed: json["speed"],
      id: json["id"],
      isAvailable: json["isAvailable"] ?? false,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "price": this.price,
      "speed": this.speed,
      "id": this.id,
      "isAvailable": this.isAvailable ?? false,

    };
  }


}