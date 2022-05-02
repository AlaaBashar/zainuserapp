import 'package:zainusersapp/models/areas_model.dart';
import 'package:zainusersapp/models/user_model.dart';


class VisitsModel {
  String? gender;
  String? nationality;
  String? areaId;
  String? idType;
  String? dateOfBirth;
  String? firstName;
  String? secondName;
  String? thirdName;
  String? internetUsage;
  String? commitmentDuration;
  String? pricePerMonth;
  String? endVisit;
  String? id;
  String? docId;
  DateTime? date;
  UserApp? user;
  AreasModel? area;
  String? userUid;

  VisitsModel(
      {
       this.gender,
        this.area,
        this.areaId,
      this.nationality,
      this.idType,
      this.dateOfBirth,
      this.firstName,
      this.secondName,
      this.thirdName,
      this.internetUsage,
      this.commitmentDuration,
      this.pricePerMonth,
      this.endVisit,
      this.id,
        this.docId,
      this.date,
      this.user,
      this.userUid});

  factory VisitsModel.fromJson(Map<String, dynamic> json) {
    return VisitsModel(
      id: json["id"],
      areaId: json["areaId"],
      nationality: json["nationality"],
      gender: json['gender'],
      idType: json["idType"],
      dateOfBirth: json["dateOfBirth"],
      firstName: json["firstName"],
      secondName: json["secondName"],
      thirdName: json["thirdName"],
      internetUsage: json["internalUsage"],
      docId: json["docId"],
      commitmentDuration: json["commitmentDuration"],
      pricePerMonth: json["pricePerMonth"],
      endVisit: json["endVisit"],
      userUid: json["userUid"],
      date: DateTime.parse(json["date"]),
      user: UserApp.fromJson(json["user"]),
      area: AreasModel.fromJson(json["area"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "gender": gender,
      "areaId": areaId,
      "nationality": nationality,
      "idType": idType,
      "docId": docId,
      "dateOfBirth": dateOfBirth,
      "firstName": firstName,
      "secondName": secondName,
      "thirdName": thirdName,
      "internalUsage": internetUsage,
      "commitmentDuration": commitmentDuration,
      "pricePerMonth": pricePerMonth,
      "endVisit": endVisit,
      "userUid": userUid,
      "date": date!.toIso8601String(),
      "user": user!.toJson(),
      "area": area!.toJson(),

    };
  }
}

