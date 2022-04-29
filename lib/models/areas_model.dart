class AreasModel{

  String? state;

  AreasModel({this.state,});


  factory AreasModel.fromJson(Map<String, dynamic> json) {
    return AreasModel(
      state: json["state"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "state": this.state,

    };
  }


}