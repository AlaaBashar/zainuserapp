import 'package:flutter/material.dart';
import 'package:zainusersapp/models/areas_model.dart';
import 'package:zainusersapp/models/visits_model.dart';
import 'package:zainusersapp/pages/contract_page.dart';
import '../models/complaint_model.dart';
import '../models/contract_model.dart';
import '../network/api.dart';
import '../network/auth.dart';
import '../utils.dart';
import '../widget/text_field_app.dart';


class NewVisitPage extends StatefulWidget {
  AreasModel? areasModel;
   NewVisitPage({Key? key,required this.areasModel}) : super(key: key);

  @override
  _NewVisitPageState createState() => _NewVisitPageState();
}

class _NewVisitPageState extends State<NewVisitPage> {

  TextEditingController genderController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController idTypeController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController secondNameController = TextEditingController();
  TextEditingController thirdNameController = TextEditingController();
  TextEditingController internalUsageController = TextEditingController();
  TextEditingController commitmentDurationController = TextEditingController();
  TextEditingController pricePerMonthController = TextEditingController();
  TextEditingController endVisitController = TextEditingController();
  AreasModel? areasModel ;
  GlobalKey<FormState> newVisitFormKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      genderController.text = Auth.currentUser!.gender.toString();
      idController.text = Auth.currentUser!.id!.toString() ;
      areasModel = widget.areasModel;
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('انشاء زيارة جديد'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: newVisitFormKey,
          child: Container(
            margin: const EdgeInsets.only(top: 30.0),
            child: Column(
              children: [

                TextFieldApp(
                  controller: firstNameController,
                  hintText: 'الاسم الأول',
                  icon: const Icon(Icons.text_fields),
                  isRTL: true,
                  type: TextInputType.name,
                  validator: (str) => str!.isEmpty ? 'يرجى ادخال الاسم الأول' : null,
                ),
                TextFieldApp(
                  controller: secondNameController,
                  hintText: 'الاسم الثاني',
                  icon: const Icon(Icons.text_fields),
                  isRTL: true,
                  type: TextInputType.name,
                  validator: (str) => str!.isEmpty ? 'يرجى ادخال الاسم الثاني' : null,
                ),
                TextFieldApp(
                  controller: thirdNameController,
                  hintText: 'الاسم الثالث',
                  icon: const Icon(Icons.text_fields),
                  isRTL: true,
                  type: TextInputType.name,
                  validator: (str) => str!.isEmpty ? 'يرجى ادخال الاسم الثالث' : null,
                ),
                TextFieldApp(
                  controller: idController,
                  hintText: 'ID',
                  icon: const Icon(Icons.app_registration),
                  isRTL: true,
                  type: TextInputType.number,
                  validator: (str) => str!.isEmpty ? 'يرجى ادخال ID' : null,
                ),
                TextFieldApp(
                  controller: idTypeController,
                  hintText: 'ID no',
                  icon: const Icon(Icons.drive_file_rename_outline),
                  isRTL: true,
                  type: TextInputType.text,
                  validator: (str) => str!.isEmpty ? 'يرجى ادخال ID no' : null,
                ),
                TextFieldApp(
                  controller: dateOfBirthController,
                  hintText: 'تاريخ الميلاد',
                  icon: const Icon(Icons.event),
                  isRTL: true,
                  type: TextInputType.datetime,
                  validator: (str) => str!.isEmpty ? 'يرجى ادخال تاريخ الولادة' : null,
                ),
                TextFieldApp(
                  controller: genderController,
                  hintText: 'الجنس',
                  icon: const Icon(Icons.wc),
                  isRTL: true,
                  type: TextInputType.text,
                  validator: (str) =>
                  str!.length < 10 ? 'يرجى ادخال الجنس' : null,

                ),
                TextFieldApp(
                  controller: nationalityController,
                  hintText: 'الجنسية',
                  icon: const Icon(Icons.account_balance),
                  isRTL: true,
                  type: TextInputType.text,
                  validator: (str) => str!.isEmpty ? 'يرجى ادخال الجنسية' : null,
                ),
                TextFieldApp(
                  controller: internalUsageController,
                  hintText: 'internet usage',
                  icon: const Icon(Icons.wifi),
                  isRTL: true,
                  type: TextInputType.text,
                  validator: (str) => str!.isEmpty ? 'يرجى ادخال internet usage' : null,
                ),
                TextFieldApp(
                  controller: commitmentDurationController,
                  hintText: 'مدة الالتزام',
                  icon: const Icon(Icons.watch),
                  isRTL: true,
                  type: TextInputType.number,
                  validator: (str) =>
                  str!.isEmpty ? 'يرجى ادخال مدة الالتزام' : null,
                ),
                TextFieldApp(
                  controller: pricePerMonthController,
                  hintText: 'السعر لكل شهر',
                  icon: const Icon(Icons.monetization_on_outlined),
                  isRTL: true,
                  type: const TextInputType.numberWithOptions(),
                  validator: (str) =>
                  str!.isEmpty ? 'يرجى ادخال السعر لكل شهر' : null,
                ),
                TextFieldApp(
                  controller: endVisitController,
                  hintText: 'نهاية الزيارة',
                  icon: const Icon(Icons.calendar_today),
                  isRTL: true,
                  type: const TextInputType.numberWithOptions(),
                  validator: (str) =>
                  str!.isEmpty ? 'يرجى ادخال السعر لكل شهر' : null,
                ),

                Container(
                  width: getScreenWidth(context),
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: ElevatedButton(
                    child: const Text(
                      'انشاء زيارة جديدة',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    onPressed: onCreateNewVisit,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void onCreateNewVisit()async{
    if (!newVisitFormKey.currentState!.validate()) return;
    FocusManager.instance.primaryFocus?.unfocus();
    String? gender = genderController.text.trim().toString();
    String? nationality = nationalityController.text.trim();
    String? idType = idTypeController.text.trim();
    String? id = idController.text.trim();
    String? dateOfBirth = dateOfBirthController.text;
    String? firstName = firstNameController.text.trim();
    String? secondName = secondNameController.text.trim();
    String? thirdName = thirdNameController.text.trim();
    String? internalUsage = internalUsageController.text;
    String? commitmentDuration = commitmentDurationController.text.trim();
    String? pricePerMonth = pricePerMonthController.text.trim();
    String? endVisit = endVisitController.text.trim();

    ProgressCircleDialog.show(context);

    VisitsModel visitsModel = VisitsModel();
    visitsModel
      ..gender = gender
      ..areaId = areasModel!.id
      ..nationality = nationality
      ..idType = idType
      ..id=id
      ..dateOfBirth = dateOfBirth
      ..firstName = firstName
      ..secondName = secondName
      ..thirdName = thirdName
      ..internetUsage = internalUsage
      ..commitmentDuration = commitmentDuration
      ..pricePerMonth = pricePerMonth
      ..endVisit = endVisit
      ..date = DateTime.now()
      ..userUid = Auth.currentUser!.uid
      ..user = Auth.currentUser
      ..area = areasModel;
    await Api.setVisits(visitsModel);
    ProgressCircleDialog.dismiss(context);


  }
  void onNewContract() {
    openNewPage(context, const ContractPage(),popPreviousPages: true);
  }


}
