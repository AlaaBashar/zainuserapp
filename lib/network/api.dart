import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:zainusersapp/network/auth.dart';
import '../models/areas_model.dart';
import '../models/complaint_model.dart';
import '../models/contract_model.dart';
import '../models/ministries_model.dart';
import '../models/offers_model.dart';
import '../models/suggestions_model.dart';
import '../models/user_model.dart';
import '../models/visits_model.dart';
import 'Fcm.dart';
import 'constants.dart';

class Api {

  static FirebaseFirestore db = FirebaseFirestore.instance;

  static Future insertNewUser({required UserApp userApp,}) async {
    try {
      await db
          .collection(CollectionsKey.USERS)
          .doc(userApp.uid)
          .set(userApp.toJson());

      await Auth.updateUserInPref(userApp);

      return userApp;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<UserApp?> getUserFromUid(String uid) async {
    DocumentSnapshot documentSnapshot = await db.collection(CollectionsKey.USERS).doc(uid).get();

    if (documentSnapshot.data() != null) {
      Map<String, dynamic>? map = documentSnapshot.data() as Map<String, dynamic>?;
      UserApp userApp = UserApp.fromJson(map!);

      Auth.updateUserInPref(userApp);
      Auth.currentUser = userApp;
      return userApp;
    }
    return null;
  }

  static Future<List<MinistriesModel>> getMinistries() async {
    List<MinistriesModel> ministriesList = [];
    QuerySnapshot querySnapshot =
        await db.collection(CollectionsKey.MINISTRIES).get();

    ministriesList = querySnapshot.docs
        .map((e) => MinistriesModel.fromJson(
              e.data() as Map<String, dynamic>,
            ))
        .toList();

    print('======== ${ministriesList.length}');
    return ministriesList;
  }

  static Future setComplaint(ComplaintModel complaintModel) async {
    DocumentReference doc =
        db.collection(CollectionsKey.COMPLAINTS).doc(complaintModel.id);

    complaintModel.id = doc.id;

    await doc.set(complaintModel.toJson());
  }

  static Future<List<ComplaintModel>> getComplaints() async {
    List<ComplaintModel> complaintList = [];

    QuerySnapshot querySnapshot = await db
        .collection(CollectionsKey.COMPLAINTS)
        .where('userUid', isEqualTo: Auth.currentUser!.uid)
        .get();

    complaintList = querySnapshot.docs
        .map((e) => ComplaintModel.fromJson(e.data() as Map<String, dynamic>))
        .toList();

    if (complaintList.isNotEmpty) {
      complaintList.sort((a, b) => b.date!.compareTo(a.date!));
    }

    return complaintList;
  }

  static Future<List<SuggestionModel>> getSuggestions() async {
    List<SuggestionModel> suggestionsList = [];

    QuerySnapshot querySnapshot = await db
        .collection(CollectionsKey.SUGGESTIONS)
        .where('userUid', isEqualTo: Auth.currentUser!.uid)
        .get();

    suggestionsList = querySnapshot.docs
        .map((e) => SuggestionModel.fromJson(e.data() as Map<String, dynamic>))
        .toList();

    if (suggestionsList.isNotEmpty) {
      suggestionsList.sort((a, b) => b.date!.compareTo(a.date!));
    }

    return suggestionsList;
  }

  static Future setSuggestion(SuggestionModel model) async {
    DocumentReference doc = db.collection(CollectionsKey.SUGGESTIONS).doc();

    model.id = doc.id;
    await doc.set(model.toJson());

    Fcm.sendNotificationToAdmin('يوجد اقتراح جديد من (${model.user!.name})',
        'الاقتراح : ${model.title}');
  }

  static Future<List<ContractModel>> getContracts() async {
    List<ContractModel> contractsList = [];

    QuerySnapshot querySnapshot = await db
        .collection(CollectionsKey.CONTRACTS)
        .where('userUid', isEqualTo: Auth.currentUser!.uid)
        .get();

    contractsList = querySnapshot.docs
        .map((e) => ContractModel.fromJson(e.data() as Map<String, dynamic>))
        .toList();

    if (contractsList.isNotEmpty) {
      contractsList.sort((a, b) => b.date!.compareTo(a.date!));
    }

    return contractsList;
  }

  static Future setContract(ContractModel model) async {
    DocumentReference doc = db.collection(CollectionsKey.CONTRACTS).doc();

    model.id = doc.id;
    await doc.set(model.toJson());

    Fcm.sendNotificationToAdmin('يوجد عقد جديد من (${model.user!.name})',
        'عقد : ${model.employeeName}');
  }

  static Future editContract(ContractModel? model,String? docId) async {
    model!.id = docId;
    CollectionReference  doc = db.collection(CollectionsKey.CONTRACTS);
    await doc.doc(model.id).update(model.toJson());

  }

  static Future<List<VisitsModel>> getVisits() async {
    List<VisitsModel> visitsList = [];

    QuerySnapshot querySnapshot = await db
        .collection(CollectionsKey.VISITS)
        .where('userUid', isEqualTo: Auth.currentUser!.uid,)
        .get();

    visitsList = querySnapshot.docs
        .map((e) => VisitsModel.fromJson(e.data() as Map<String, dynamic>))
        .toList();

    if (visitsList.isNotEmpty) {
      visitsList.sort((a, b) => b.date!.compareTo(a.date!));
    }

    return visitsList;
  }

  static Future setVisits(VisitsModel model) async {
    DocumentReference doc = db.collection(CollectionsKey.VISITS).doc();
    model.docId = doc.id;
    await doc.set(model.toJson());

    Fcm.sendNotificationToAdmin('يوجد زيارة جديد من (${model.user!.email})','المنطقة : ${model.area!.state}');
  }

  static Future<dynamic> uploadFile({required File imageFile, required String folderPath}) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference reference =
    FirebaseStorage.instance.ref().child(folderPath).child(fileName);

    TaskSnapshot storageTaskSnapshot = await reference.putFile(imageFile);
    // TaskSnapshot storageTaskSnapshot =  uploadTask.snapshot;

    print(storageTaskSnapshot.ref.getDownloadURL());

    var dowUrl = await storageTaskSnapshot.ref.getDownloadURL();

    return dowUrl;
  }

  static Future<List<OffersModel>> getOffers() async {
    List<OffersModel> offerList = [];

    QuerySnapshot querySnapshot =
    await db.collection(CollectionsKey.OFFERS).get();

    offerList = querySnapshot.docs
        .map((e) => OffersModel.fromJson(e.data() as Map<String, dynamic>))
        .toList();

    // if(offerList.isNotEmpty) {
    //   offerList.sort((a, b) => b.date!.compareTo(a.date!));
    // }

    return offerList;
  }

  static Future<List<AreasModel>> getAreas() async {
    List<AreasModel> areasList = [];

    QuerySnapshot querySnapshot = await db.collection(CollectionsKey.AREAS).get();

    areasList = querySnapshot.docs
        .map((e) => AreasModel.fromJson(e.data() as Map<String, dynamic>))
        .toList();

    // if(offerModel.isNotEmpty) {
    //   offerModel.sort((a, b) => b.date!.compareTo(a.date!));
    // }

    return areasList;
  }

}
