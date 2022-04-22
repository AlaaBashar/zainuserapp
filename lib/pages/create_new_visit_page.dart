import 'package:flutter/material.dart';
import 'package:zainusersapp/models/visits_model.dart';
import 'package:zainusersapp/pages/contract_page.dart';
import '../models/complaint_model.dart';
import '../models/contract_model.dart';
import '../network/api.dart';
import '../network/auth.dart';
import '../utils.dart';
import '../widget/text_field_app.dart';


class NewVisitPage extends StatefulWidget {
  const NewVisitPage({Key? key}) : super(key: key);

  @override
  _NewVisitPageState createState() => _NewVisitPageState();
}

class _NewVisitPageState extends State<NewVisitPage> {

  TextEditingController genderController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  TextEditingController idTypeController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController secondNameController = TextEditingController();
  TextEditingController thirdNameController = TextEditingController();
  TextEditingController internalUsageController = TextEditingController();
  TextEditingController commitmentDurationController = TextEditingController();
  TextEditingController pricePerMonthController = TextEditingController();
  TextEditingController endVisitController = TextEditingController();
  GlobalKey<FormState> newVisitFormKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('انشاء عقد جديد'),
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
                  controller: genderController,
                  hintText: 'جنس',
                  icon: const Icon(Icons.person),
                  isRTL: true,
                  type: TextInputType.text,
                  validator: (str) =>
                  str!.length < 10 ? 'الاسم من اربع مقاطع' : null,

                ),
                TextFieldApp(
                  controller: nationalityController,
                  hintText: 'جنسية',
                  icon: const Icon(Icons.phone),
                  isRTL: true,
                  type: TextInputType.phone,
                  validator: (str) => str!.isEmpty ? 'رقم الموبايل غير صحيح' : null,
                ),
                TextFieldApp(
                  controller: idTypeController,
                  hintText: 'نوع ID',
                  icon: const Icon(Icons.home_filled),
                  isRTL: true,
                  type: TextInputType.text,
                  validator: (str) => str!.isEmpty ? 'يرجى ادخال رقم البناء' : null,
                ),
                TextFieldApp(
                  controller: dateOfBirthController,
                  hintText: 'تاريخ الولادة',
                  icon: const Icon(Icons.local_offer),
                  isRTL: true,
                  type: TextInputType.text,
                  validator: (str) => str!.isEmpty ? 'يرجى ادخال العرض' : null,
                ),
                TextFieldApp(
                  controller: firstNameController,
                  hintText: 'الاسم الأول',
                  icon: const Icon(Icons.speed),
                  isRTL: true,
                  type: TextInputType.phone,
                  validator: (str) => str!.isEmpty ? 'يرجى ادخال السرعة' : null,
                ),
                TextFieldApp(
                  controller: secondNameController,
                  hintText: 'الاسم الثاني',
                  icon: const Icon(Icons.access_time),
                  isRTL: true,
                  type: TextInputType.text,
                  validator: (str) => str!.isEmpty ? 'يرجى ادخال مدة الالتزام' : null,
                ),
                TextFieldApp(
                  controller: thirdNameController,
                  hintText: 'الاسم الثالث',
                  icon: const Icon(Icons.access_time),
                  isRTL: true,
                  type: TextInputType.text,
                  validator: (str) => str!.isEmpty ? 'يرجى ادخال مدة الالتزام' : null,
                ),
                TextFieldApp(
                  controller: internalUsageController,
                  hintText: 'استخدام داخلي',
                  icon: const Icon(Icons.drive_file_rename_outline),
                  isRTL: true,
                  type: TextInputType.text,
                  validator: (str) => str!.isEmpty ? 'يرجى ادخال توقيع العميل' : null,
                ),
                TextFieldApp(
                  controller: commitmentDurationController,
                  hintText: 'مدة الالتزام',
                  icon: const Icon(Icons.person_pin),
                  isRTL: true,
                  type: TextInputType.text,
                  validator: (str) =>
                  str!.length < 10 ? 'الاسم من اربع مقاطع' : null,
                ),
                Container(
                  width: getScreenWidth(context),
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: ElevatedButton(
                    child: const Text(
                      'انشاء عقد جديد',
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
    String? gender = nationalityController.text;
    String? nationality = nationalityController.text;
    String? idType = idTypeController.text;
    String? dateOfBirth = dateOfBirthController.text;
    String? firstName = firstNameController.text;
    String? secondName = secondNameController.text;
    String? thirdName = thirdNameController.text;
    String? internalUsage = internalUsageController.text;
    String? commitmentDuration = commitmentDurationController.text;
    String? pricePerMonth = pricePerMonthController.text;
    String? endVisit = endVisitController.text;

    ProgressCircleDialog.show(context);

    VisitsModel visitsModel = VisitsModel();
    visitsModel
      ..gender = gender
      ..nationality = nationality
      ..idType = idType
      ..dateOfBirth = dateOfBirth
      ..firstName = firstName
      ..secondName = secondName
      ..thirdName = thirdName
      ..internalUsage = internalUsage
      ..commitmentDuration = commitmentDuration
      ..pricePerMonth = pricePerMonth
      ..endVisit = endVisit
      ..date = DateTime.now()
      ..userUid = Auth.currentUser!.uid
      ..user = Auth.currentUser;
    await Api.setVisits(visitsModel);
    ProgressCircleDialog.dismiss(context);


  }
  void onNewContract() {
    openNewPage(context, const ContractPage(),popPreviousPages: true);
  }


}
