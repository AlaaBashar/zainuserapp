import 'package:zainusersapp/models/user_model.dart';

import '../export_feature.dart';

class SuggestionModel {
  String? id;
  String? title;
  String? des;
  DateTime? date;
  UserApp? user;
  String? userUid;
  SuggestionStatus? suggestionsStatus;

  SuggestionModel(
      {this.id,
      this.title,
      this.des,
      this.date,
      this.user,
      this.userUid,
      this.suggestionsStatus});

  factory SuggestionModel.fromJson(Map<String, dynamic> json) {
    return SuggestionModel(
      id: json["id"],
      title: json["title"],
      des: json["des"],
      userUid: json["userUid"],
      suggestionsStatus: enumValueFromString(
        json["suggestionsStatus"],
        SuggestionStatus.values,
        onNull: SuggestionStatus.Pending,
      ),
      date: DateTime.parse(json["date"]),
      user: UserApp.fromJson(json["user"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "des": des,
      "userUid": userUid,
      "suggestionsStatus": getStringFromEnum(suggestionsStatus!),
      "date": date!.toIso8601String(),
      "user": user!.toJson(),
    };
  }
}

enum SuggestionStatus { Pending, Approve, Rejected }
