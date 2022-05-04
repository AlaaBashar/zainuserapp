import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zainusersapp/models/areas_model.dart';
import 'package:zainusersapp/models/visits_model.dart';
import 'package:zainusersapp/pages/contract_page.dart';
import '../models/user_model.dart';
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
  Gender genderSelected = Gender.Male;
  AreasModel? areasModel ;
  GlobalKey<FormState> newVisitFormKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
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
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.parse('1960-01-01') ,
                      lastDate: DateTime.parse('2032-05-03'),
                    ).then((value) {
                      if(value != null) {
                        setState(() {
                        dateOfBirthController.text = DateFormat.yMMMd().format(value);
                      });

                      }
                      else{
                        return;
                      }
                     });
                  },
                  validator: (str) => str!.isEmpty ? 'يرجى ادخال تاريخ الميلاد' : null,
                ),
                Container(
                  margin:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                          child: InkWell(
                            onTap: onPressedMale,
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              height: 45.0,
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: genderSelected == Gender.Male
                                        ? Colors.blueAccent
                                        : Colors.transparent,
                                    width: 1),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 0,
                                    blurRadius: 5,
                                    offset:
                                    const Offset(0, 2), // changes position of shadow
                                  )
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.male,
                                      color: genderSelected == Gender.Male
                                          ? Colors.blueAccent
                                          : Colors.grey),
                                  const Spacer(),
                                  Text(
                                    'ذكر',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: genderSelected == Gender.Male
                                            ? Colors.blueAccent
                                            : Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .color),
                                  ),
                                  const Spacer(
                                    flex: 4,
                                  ),
                                ],
                              ),
                            ),
                          )),
                      const SizedBox(
                        width: 16.0,
                      ),
                      Expanded(
                          child: InkWell(
                            onTap: onPressedFemale,
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              height: 45.0,
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: genderSelected == Gender.Female
                                        ? Colors.blueAccent
                                        : Colors.transparent,
                                    width: 1),
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 0,
                                    blurRadius: 5,
                                    offset:
                                    const Offset(0, 2), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.female,
                                      color: genderSelected == Gender.Female
                                          ? Colors.blueAccent
                                          : Colors.grey),
                                  const Spacer(),
                                  Text(
                                    'انثى',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: genderSelected == Gender.Female
                                            ? Colors.blueAccent
                                            : Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .color),
                                  ),
                                  const Spacer(
                                    flex: 4,
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
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
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    FocusScope.of(context).requestFocus(FocusNode());

                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now() ,
                      lastDate: DateTime.parse('2025-05-03'),
                    ).then((value) {
                      if(value != null) {
                        setState(() {
                          endVisitController.text = DateFormat.yMMMd().format(value);
                        });

                      }
                      else{
                        return;
                      }
                    });
                  },
                  type: const TextInputType.numberWithOptions(),
                  validator: (str) =>
                  str!.isEmpty ? 'يرجى ادخال نهاية الزيارة' : null,
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

  void onPressedMale() {
    genderSelected = Gender.Male;

    setState(() {});
  }

  void onPressedFemale() {
    genderSelected = Gender.Female;

    setState(() {});
  }
  void onCreateNewVisit()async{
    if (!newVisitFormKey.currentState!.validate()) return;
    FocusManager.instance.primaryFocus?.unfocus();
    String? gender = genderSelected.toString();
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
    Navigator.pop(context , true);
  }


}
